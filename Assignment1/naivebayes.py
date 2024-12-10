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
    
    # def fit(self, train_texts, train_labels):
    #     X = self.vectorizer.fit_transform(train_texts)
    #     self.feature_names = self.vectorizer.get_feature_names_out()
        
    #     label_counts = Counter(train_labels)
    #     self.priors = {label: count / len(train_labels) for label, count in label_counts.items()}
        
    #     for label, vector in zip(train_labels, X.toarray()):
    #         if label in self.vocab_per_label_dict:
    #             self.vocab_per_label_dict[label] += vector
    #         else:
    #             self.vocab_per_label_dict[label] = vector
        
    #     self.total_per_label = {label: np.sum(vector) for label, vector in self.vocab_per_label_dict.items()}
        
    #     self.word_probabilities = {}
    #     for label, vector in self.vocab_per_label_dict.items():
    #         word_prob_list = [(count + 1) / (self.total_per_label[label] + len(self.feature_names)) 
    #                           for count in vector]  # Laplace Smoothing

    #         # word_prob_list = [count / self.total_per_label[label] if count != 0 else 0 for count in vector]

    #         self.word_probabilities[label] = np.array(word_prob_list)

    def fit(self, train_texts, train_labels):
        # Transform texts into a sparse matrix
        X = self.vectorizer.fit_transform(train_texts)
        self.feature_names = self.vectorizer.get_feature_names_out()

        # Calculate priors (label probabilities)
        label_counts = Counter(train_labels)
        total_labels = len(train_labels)
        self.priors = {label: count / total_labels for label, count in label_counts.items()}

        # Initialize a defaultdict to accumulate feature vectors per label
        vocab_per_label = defaultdict(lambda: np.zeros(X.shape[1]))

        # Accumulate vectors for each label directly from the sparse matrix
        for label, row in zip(train_labels, X):
            vocab_per_label[label] += row.toarray()[0]

        # Calculate total words per label
        self.total_per_label = {label: np.sum(vector) for label, vector in vocab_per_label.items()}

        # Calculate word probabilities with Laplace Smoothing
        self.word_probabilities = {
            label: (vector + 1) / (self.total_per_label[label] + len(self.feature_names))
            for label, vector in vocab_per_label.items()
        }

    
    def predict(self, test_text): ###singles
        # Transform the single test text into the vector representation
        X_test = self.vectorizer.transform([test_text])
        test_vector = X_test.toarray()[0]  # Get the first (and only) vector

        results = {}
        
        for label in self.word_probabilities.keys():
            class_probabilities = []
            for i, word_count in enumerate(test_vector):
                word_prob = self.word_probabilities[label][i]
                if word_prob > 0:
                    class_probabilities.append(word_count * math.log(word_prob))
            
            # Calculate the log of the prior probability and the sum of class probabilities
            results[label] = math.log(self.priors[label]) + sum(class_probabilities)

        # Find the label with the maximum score
        max_key = max(results, key=lambda k: results[k])
        return max_key
        
    # def predict(self, test_texts): #### multiples
    #     X_test = self.vectorizer.transform(test_texts)
    #     predictions = []
        
    #     for test_vector in X_test.toarray():
    #         results = {}
            
    #         for label in self.word_probabilities.keys():
    #             class_probabilities = []
    #             for i, word_count in enumerate(test_vector):
    #                 word_prob = self.word_probabilities[label][i]
    #                 if word_prob > 0:
    #                     class_probabilities.append(word_count * math.log(word_prob))                
    #             results[label] = math.log(self.priors[label]) + sum(class_probabilities)
            
    #         max_key = max(results, key=lambda k: results[k])
    #         predictions.append(max_key)
        
    #     return predictions