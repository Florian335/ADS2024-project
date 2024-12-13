CREATE OR REPLACE FUNCTION BADGER_DB.PUBLIC.TRAIN_AND_PREDICT_CLASSIFIER(
    "MODE" VARCHAR(16777216), 
    "LABEL" VARCHAR(16777216), 
    "TEXT" VARCHAR(16777216)
)
RETURNS TABLE ("FEATURE" VARCHAR(16777216), "LABEL" VARCHAR(16777216), "PROBABILITY" VARCHAR(16777216))
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('numpy', 'pandas', 'scikit-learn')
HANDLER = 'TrainUDTF'
AS '
import math
import numpy as np
from collections import Counter, defaultdict
from sklearn.feature_extraction.text import CountVectorizer

class NaiveBayesTextClassifier:
    def __init__(self):
        self.vectorizer = CountVectorizer()
        self.priors = {}
        self.word_probabilities = {}

    def fit(self, train_texts, train_labels):
        X = self.vectorizer.fit_transform(train_texts)
        self.feature_names = self.vectorizer.get_feature_names_out()

        label_counts = Counter(train_labels)
        total_labels = len(train_labels)
        self.priors = {label: count / total_labels for label, count in label_counts.items()}

        vocab_per_label = defaultdict(lambda: np.zeros(X.shape[1]))

        for label, row in zip(train_labels, X):
            vocab_per_label[label] += row.toarray()[0]

        total_per_label = {label: np.sum(vector) for label, vector in vocab_per_label.items()}

        self.word_probabilities = {
            label: vector / total_per_label[label]
            for label, vector in vocab_per_label.items()
        }


class TrainUDTF:
    def __init__(self):
        self.mode = None
        self.labels = []
        self.texts = []
        self.model_parameters = []
        self.classifier = None

    def process(self, mode, label, text):
        self.mode = mode
        if mode == "TRAIN":
            self.labels.append(label)
            self.texts.append(text)

    def end_partition(self):
        if self.mode == "TRAIN":
            self.classifier = NaiveBayesTextClassifier()
            self.classifier.fit(self.texts, self.labels)

            for lbl, p in self.classifier.priors.items():
                yield ("__PRIOR__", lbl, str(p))

            for lbl, probs in self.classifier.word_probabilities.items():
                for i, prob in enumerate(probs):
                    yield (self.classifier.feature_names[i], lbl, str(prob))

';
CREATE OR REPLACE TABLE MODEL_PARAMETERS AS
SELECT results.*
FROM (
    SELECT 'TRAIN' AS mode,
           parse_json(u.COL1):label::string AS label,
           parse_json(u.COL1):text::string AS text,
    FROM TRAINING AS u
    WHERE parse_json(u.COL1):label::string IN ('0', '1') -- Filter labels
    LIMIT 1000
) AS data,
     TABLE(train_and_predict_classifier(data.mode, data.label, data.text) OVER ()) AS results
;