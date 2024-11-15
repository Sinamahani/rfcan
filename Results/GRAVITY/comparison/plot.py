import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import pearsonr
from sklearn.preprocessing import MinMaxScaler

# Load your CSV file
file_path = "/Users/sina/Desktop/RFCAN/rfcan/Results/GRAVITY/comparison/comp-selected.csv"
data = pd.read_csv(file_path)

# Normalize both gravity and moho using Min-Max normalization (scaling between 0 and 1)
scaler = MinMaxScaler()
data[['gravity_norm', 'moho_norm']] = scaler.fit_transform(data[['gravity', 'moho']])
#filter data based on n=1
data = data[data['moho']<40000]
# data = data[data['misfit'] <=0.14]

# Set plot style for publication
sns.set(style="whitegrid", context="talk", palette="muted")

# 1. Fancy Scatter Plot of Normalized Moho vs Normalized Gravity
plt.figure(figsize=(8, 4), dpi=300)

# Scatter plot with trendline
sns.regplot(x=data['gravity_norm'], y=data['moho_norm'], scatter_kws={'s': 80, 'color': 'dodgerblue'}, 
            line_kws={'color': 'darkorange', 'lw': 2}, ci=None)

# Add title and labels
plt.title('Relationship Between Gravity and Moho Depth', fontsize=20, weight='bold')
plt.xlabel('Normalized Gravity', fontsize=16)
plt.ylabel('Normalized Moho Depth', fontsize=16)

# Customize ticks
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)

# Show plot with improved aesthetics
plt.tight_layout()
plt.show()

# 2. Pearson Correlation
correlation, p_value = pearsonr(data['gravity_norm'], data['moho_norm'])
print(f"Pearson Correlation Coefficient (Normalized): {correlation:.2f}")
print(f"P-value: {p_value:.4f}")

# 3. Difference Plot of Normalized Values (Gravity - Moho)
plt.figure(figsize=(8, 4), dpi=300)

# Calculate normalized difference and sort data by station
data['normalized_difference'] = data['gravity_norm'] - data['moho_norm']
data = data.sort_values('station')

# Line plot of normalized differences
sns.lineplot(x=data['station'], y=data['normalized_difference'], lw=2, marker='o', markersize=8, color='crimson')

# Add title and labels
plt.title('Difference Between Gravity and Moho by Station', fontsize=20, weight='bold')
plt.xlabel('Station', fontsize=16)
plt.ylabel('Normalized Gravity - Moho', fontsize=16)

# Customize x-ticks and y-ticks
plt.xticks(fontsize=14, rotation=90)
plt.yticks(fontsize=14)

# Add gridlines
plt.grid(True, which='both', linestyle='--', linewidth=0.5)

# Clean layout
plt.tight_layout()
plt.show()