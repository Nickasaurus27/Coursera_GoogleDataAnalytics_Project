# Cyclistic Bike-Share Case Study 
### *Google Data Analytics Certificate Capstone Project*

---

## 📌 Project Overview
This repository contains the code, queries, and analytical workflow for my capstone project completing the **Google Data Analytics Professional Certificate**. 

The goal of this project is to analyze historical trip data from a fictional Chicago-based bike-share company, **Cyclistic**, to understand how **annual members** and **casual riders** use the service differently. These insights will help the marketing team, led by Director Lily Moreno, design strategies to convert casual riders into high-value annual members [cite: 1, 2].

---

## 🎯 Business Task
> **How do annual members and casual riders use Cyclistic bikes differently?** [cite: 1, 2]

---

## 🛠️ Tech Stack & Tools Used
* **R (RStudio)**: Primary tool used for data merging, transformation, cleaning, statistical analysis, and data visualization (`tidyverse`, `lubridate`, `geosphere`, `scales`, `ggplot2`) [cite: 1, 3].
* **SQL (PostgreSQL)**: Used for initial database setup, schema definitions, exploratory queries, and table unions (`UNION ALL`, `ALTER TABLE`, `CREATE VIEW`) [cite: 1, 4].
* **Excel**: Initial data inspection, header verification, and schema validation [cite: 1].

---

## 📂 Data Source & Structure
The analysis uses 12 months of historical trip data from **January 2021 to December 2021** [cite: 1]. The raw data is publicly available and provided by Motivate International Inc. under this [license agreement](https://ride.divvybikes.com/data-license-agreement) [cite: 1, 2].

### Dataset Schema
Each of the 12 CSV files shared a consistent structure:
* `ride_id`: Unique identifier for each trip [cite: 1].
* `rideable_type`: Type of bike (`classic`, `electric`, or `docked`) [cite: 1].
* `started_at` / `ended_at`: Timestamp (Date & Time) of start/end [cite: 1].
* `start_station_name` / `end_station_name`: Names of stations [cite: 1].
* `start_lat` / `start_lng` / `end_lat` / `end_lng`: Coordinates [cite: 1].
* `member_casual`: Classification of the rider (`member` or `casual`) [cite: 1].

---

## 🧼 Data Cleaning & Feature Engineering
With over **5 million rows** of data, processing was handled programmatically [cite: 1]. 

### Key Transformations & Cleansing Steps:
1. **Empty Values**: Converted blank string values (`""`) in station IDs and names to explicit `NA` to handle missing values consistently [cite: 1, 3].
2. **Filtering**: Removed trips with missing station IDs (~13% of rows), trips with a duration of $\le 0$ minutes, and trips with an calculated distance of $0$ meters [cite: 1, 3].
3. **Calculated Columns Added**:
   * `ride_length_mins`: Trip duration calculated as `(ended_at - started_at) / 60` [cite: 1, 3].
   * `ride_distance_m`: Calculated geographical distance (meters) using the Haversine formula (`geosphere::distHaversine`) on latitude/longitude coordinates [cite: 1, 3].
   * `ride_month`: Extracted month name [cite: 1, 3].
   * `day_of_week`: Day of the week numerical factor ($1 = 	ext{Sunday}$, $7 = 	ext{Saturday}$) [cite: 1, 3].
   * `hour_of_day`: Trip start hour ($0$ to $23$) [cite: 1, 3].

---

## 📊 Key Findings & Insights

### 1. Trip Duration & Distance
* **Casual riders ride much longer**: The average ride duration of casual riders is **more than double** that of annual members [cite: 1, 4].
* Annual members have shorter, highly consistent trip durations, indicating utilitarian usage (e.g., daily commuting) [cite: 1].

### 2. Time-Based Behavior
* **Weekday vs. Weekend**: Annual members ride more during the weekdays (Monday–Friday) [cite: 1, 4]. Casual riders dominate the weekends, peaking heavily on **Saturdays** [cite: 1].
* **Hourly Spikes**: Members exhibit clear commuter spikes at **7:00 AM – 8:00 AM** and **5:00 PM – 6:00 PM** [cite: 1]. Casual rider activity increases steadily throughout the day, peaking in the afternoon without distinct rush-hour spikes [cite: 1].
* **Seasonality**: Both groups peak in summer (July/August), but annual members continue riding at higher relative rates throughout the colder winter months [cite: 1].

### 3. Bike Preferences
* **Classic bikes** are the most popular choice for both groups [cite: 1].
* **Docked bikes** are almost *exclusively* used by casual riders [cite: 1].

---

## 💡 Strategic Recommendations

1. **Seasonal Weekend Memberships**: Introduce a summer/weekend-specific pass or discounted seasonal annual memberships targeted at casual riders during peak months (June–August) [cite: 1].
2. **"Keep it Classic" Promotion**: Since casual riders favor classic bikes for longer, leisure rides, market the comfort and health benefits of classic bikes for weekend exploration, emphasizing the financial savings of an annual membership for longer trips [cite: 1].
3. **Targeted Digital Campaigns**: Run digital ads at high-volume casual stations during weekend afternoon peak hours to capture casual users while they are actively riding.

---

## 📈 Code Artifacts
* Detailed R analysis, cleaning scripts, and visualization code: **[`CapstoneProject.R`](CapstoneProject.R)** [cite: 3]
* SQL exploratory analysis queries: **[`BikingSQLQueries.sql`](BikingSQLQueries.sql)** [cite: 4]

---
*Created by **Nick Assuras** as part of the Google Data Analytics Professional Certificate program.* [cite: 1]
