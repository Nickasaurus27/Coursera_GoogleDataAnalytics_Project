# Cyclistic Bike-Share Case Study 
### *Google Data Analytics Certificate Capstone Project*

---

## 📌 Project Overview
This repository contains the code, queries, and analytical workflow for my capstone project completing the **Google Data Analytics Professional Certificate**. 

The goal of this project is to analyze historical trip data from a fictional Chicago-based bike-share company, **Cyclistic**, to understand how **annual members** and **casual riders** use the service differently. These insights will help the marketing team, led by Director Lily Moreno, design strategies to convert casual riders into high-value annual members.

---

## 🎯 Business Task
> **How do annual members and casual riders use Cyclistic bikes differently?**

---

## 🛠️ Tech Stack & Tools Used
* **R (RStudio)**: Primary tool used for data merging, transformation, cleaning, statistical analysis, and data visualization (`tidyverse`, `lubridate`, `geosphere`, `scales`, `ggplot2`).
* **SQL (PostgreSQL)**: Used for initial database setup, schema definitions, exploratory queries, and table unions (`UNION ALL`, `ALTER TABLE`, `CREATE VIEW`).
* **Excel**: Initial data inspection, header verification, and schema validation.

---

## 📂 Data Source & Structure
The analysis uses 12 months of historical trip data from **January 2021 to December 2021**. The raw data is publicly available and provided by Motivate International Inc. under this [license agreement](https://ride.divvybikes.com/data-license-agreement).

### Dataset Schema
Each of the 12 CSV files shared a consistent structure:
* `ride_id`: Unique identifier for each trip.
* `rideable_type`: Type of bike (`classic`, `electric`, or `docked`).
* `started_at` / `ended_at`: Timestamp (Date & Time) of start/end.
* `start_station_name` / `end_station_name`: Names of stations.
* `start_lat` / `start_lng` / `end_lat` / `end_lng`: Coordinates.
* `member_casual`: Classification of the rider (`member` or `casual`).

---

## 🧼 Data Cleaning & Feature Engineering
With over **5 million rows** of data, processing was handled programmatically. 

### Key Transformations & Cleansing Steps:
1. **Empty Values**: Converted blank string values (`""`) in station IDs and names to explicit `NA` to handle missing values consistently.
2. **Filtering**: Removed trips with missing station IDs (~13% of rows), trips with a duration of $\le 0$ minutes, and trips with a calculated distance of $0$ meters.
3. **Calculated Columns Added**:
   * `ride_length_mins`: Trip duration calculated as `(ended_at - started_at) / 60`.
   * `ride_distance_m`: Calculated geographical distance (meters) using the Haversine formula (`geosphere::distHaversine`) on latitude/longitude coordinates.
   * `ride_month`: Extracted month name.
   * `day_of_week`: Day of the week numerical factor ($1 = 	ext{Sunday}$, $7 = 	ext{Saturday}$).
   * `hour_of_day`: Trip start hour ($0$ to $23$).

---

## 📊 Key Findings & Insights

### 1. Trip Duration & Distance
* **Casual riders ride much longer**: The average ride duration of casual riders is **more than double** that of annual members.
* Annual members have shorter, highly consistent trip durations, indicating utilitarian usage (e.g., daily commuting).

### 2. Time-Based Behaviour
* **Weekday vs. Weekend**: Annual members ride more during the weekdays (Monday–Friday). Casual riders dominate the weekends, peaking heavily on **Saturdays**.
* **Hourly Spikes**: Members exhibit clear commuter spikes at **7:00 AM – 8:00 AM** and **5:00 PM – 6:00 PM**. Casual rider activity increases steadily throughout the day, peaking in the afternoon without distinct rush-hour spikes.
* **Seasonality**: Both groups peak in summer (July/August), but annual members continue riding at higher relative rates throughout the colder winter months.

### 3. Bike Preferences
* **Classic bikes** are the most popular choice for both groups.
* **Docked bikes** are almost *exclusively* used by casual riders.

---

## 💡 Strategic Recommendations

1. **Seasonal Weekend Memberships**: Introduce a summer/weekend-specific pass or discounted seasonal annual memberships targeted at casual riders during peak months (June–August).
2. **"Keep it Classic" Promotion**: Since casual riders favor classic bikes for longer, leisure rides, market the comfort and health benefits of classic bikes for weekend exploration, emphasizing the financial savings of an annual membership for longer trips.
3. **Targeted Digital Campaigns**: Run digital ads at high-volume casual stations during weekend afternoon peak hours to capture casual users while they are actively riding.

---

## 📈 Code Artifacts
* Detailed R analysis, cleaning scripts, and visualization code: **[`CapstoneProject.R`](CapstoneProject.R)**
* SQL exploratory analysis queries: **[`BikingSQLQueries.sql`](BikingSQLQueries.sql)**

---
*Created by **Nick Assuras** as part of the Google Data Analytics Professional Certificate program.*
