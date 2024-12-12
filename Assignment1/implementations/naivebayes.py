import math
import numpy as np
from collections import Counter, defaultdict
from sklearn.feature_extraction.text import CountVectorizer

class NaiveBayesTextClassifier:
    def __init__(self):
        self.vectorizer = CountVectorizer()
        self.priors = {}
        self.vocab_per_label_dict = {}
        self.total_per_label = {}
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

        self.total_per_label = {label: np.sum(vector) for label, vector in vocab_per_label.items()}

        self.word_probabilities = {
            label: (vector + 1) / (self.total_per_label[label] + len(self.feature_names))
            for label, vector in vocab_per_label.items()
        }

        
    def predict(self, test_texts): 
        predictions = []
        X_test = self.vectorizer.transform(test_texts).toarray()  
        
        log_priors = {label: math.log(prob) for label, prob in self.priors.items()}
        
        for test_vector in X_test:
            results = {}
            
            for label, word_probs in self.word_probabilities.items():
                log_probs = np.log(np.maximum(word_probs, 1e-9))
                class_probability = log_priors[label] + np.dot(test_vector, log_probs)
                results[label] = class_probability
            
            predictions.append(max(results, key=results.get))
        
        return predictions