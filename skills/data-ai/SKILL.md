---
name: data-ai
description: Build intelligent systems with data engineering, machine learning, and AI. Master data pipelines, model development, and production ML systems.
---

# Data & AI Skills

## Quick Start

### Basic ML Model with Python
```python
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

# Load and prepare data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Train model
model = RandomForestClassifier(n_estimators=100)
model.fit(X_train, y_train)

# Evaluate
predictions = model.predict(X_test)
accuracy = accuracy_score(y_test, predictions)
print(f"Accuracy: {accuracy:.2f}")
```

### Data Pipeline Example
```python
import pandas as pd

# ETL Process
data = pd.read_csv('raw_data.csv')
data = data.dropna()  # Clean
data['feature'] = data['raw'].apply(transform)  # Transform
data.to_csv('processed_data.csv', index=False)  # Load
```

## Core Concepts

### Data Engineering
- ETL/ELT pipelines
- Data warehousing
- SQL and query optimization
- Big data technologies (Spark)
- Data quality and validation

### Machine Learning
- Supervised learning
- Unsupervised learning
- Feature engineering
- Model evaluation metrics
- Cross-validation techniques
- Hyperparameter tuning

### Deep Learning
- Neural networks fundamentals
- CNNs for computer vision
- RNNs and LSTMs
- Transformers and attention
- Transfer learning

### AI/LLMs
- Transformer architecture
- Large language models
- Prompt engineering
- Fine-tuning and adaptation
- RAG (Retrieval-Augmented Generation)

## Advanced Topics

### MLOps
- Model training automation
- Experiment tracking (MLflow, Weights & Biases)
- Model versioning
- Containerization (Docker)
- Deployment and serving (FastAPI, TensorFlow Serving)

### Data Analysis
- Exploratory Data Analysis (EDA)
- Statistical testing
- Data visualization (Matplotlib, Plotly)
- Business metrics interpretation

### AI Safety & Ethics
- Bias detection and mitigation
- Model explainability (SHAP, LIME)
- Fairness metrics
- Responsible AI principles

## Resources
- [Data Engineer Roadmap - roadmap.sh](https://roadmap.sh/dataeng)
- [Machine Learning Roadmap - roadmap.sh](https://roadmap.sh/machine-learning)
- [Fast.ai](https://www.fast.ai/)
- [Kaggle Learn](https://www.kaggle.com/learn)
