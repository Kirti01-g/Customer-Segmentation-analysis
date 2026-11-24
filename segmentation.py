import streamlit as st
import pandas as pd
import numpy as np
import joblib

# Load trained model and scaler
@st.cache_resource
def load_models():
    kmeans = joblib.load("kmeans_model.pkl")
    scaler = joblib.load("scaler.pkl")
    return kmeans, scaler

kmeans, scaler = load_models()

st.set_page_config(page_title="eCommerce Customer Segmentation", layout="wide")

st.title("🛒 eCommerce Customer Segmentation Portal")
st.write("Input customer parameters below to predict their behavioral cluster in real time.")

st.sidebar.header("Customer Profile Parameters")

# Input fields matching model feature names exactly
age = st.sidebar.number_input("Age", min_value=18, max_value=100, value=35)
income = st.sidebar.number_input("Income ($)", min_value=0, max_value=200000, value=50000)
total_spending = st.sidebar.number_input("Total Spending ($)", min_value=0, max_value=10000, value=1000)
num_web_purchases = st.sidebar.number_input("Number of Web Purchases", min_value=0, max_value=100, value=10)
num_store_purchases = st.sidebar.number_input("Number of Store Purchases", min_value=0, max_value=100, value=10)
num_web_visits = st.sidebar.number_input("Number of Web Visits per Month", min_value=0, max_value=50, value=5)
recency = st.sidebar.number_input("Recency (Days since last purchase)", min_value=0, max_value=365, value=30)

# Exact feature names required by scaler.pkl
input_data = pd.DataFrame({
    "Age": [age],
    "Income": [income],
    "Total_Spending": [total_spending],
    "NumWebPurchases": [num_web_purchases],
    "NumStorePurchases": [num_store_purchases],
    "NumWebVisitsMonth": [num_web_visits],
    "Recency": [recency]
})

col1, col2 = st.columns([1, 2])

with col1:
    st.subheader("Customer Input Summary")
    st.dataframe(input_data.T.rename(columns={0: "Value"}))

with col2:
    st.subheader("Segmentation Output")
    if st.button("Predict Customer Segment", type="primary"):
        # Scale inputs using pre-trained StandardScaler
        scaled_input = scaler.transform(input_data)
        
        # Predict cluster
        cluster = kmeans.predict(scaled_input)[0]
        
        st.success(f"### Predicted Cluster: **Cluster {cluster}**")
        
        # Provide cluster insights based on output
        cluster_info = {
            0: "🏆 **High-Value VIP:** High income and spending. Focus on retention and premium product upsells.",
            1: "🏷️ **Deal Hunter:** High website visits and deal activity. Target with discount campaigns and promo codes.",
            2: "👨‍👩‍👧 **Core Family Shopper:** Moderate income with regular store visits. Target with bundle offers.",
            3: "⚠️ **At-Risk Customer:** High recency score (inactive). Trigger re-engagement campaigns immediately."
        }
        st.info(cluster_info.get(cluster, "Customer segment successfully identified."))