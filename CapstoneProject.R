#--------------PREPARATION

#loading up libraries and setting our working directory
library(tidyverse) #helps wrangle data
library(lubridate) #helps working with dates
library(scales) #for axis labels
library(geosphere) #to be used for calculating ride distance
library(tinytex)
setwd('/Users/nickassuras/Desktop/Google Capstone Project/Case Study #1 - Biking')
getwd()

#Loading our data 
jan_rides <- read.csv('Raw Data/Jan2021_divvy_tripdata.csv')
feb_rides <- read.csv('Raw Data/Feb2021_divvy_tripdata.csv')
mar_rides <- read.csv('Raw Data/Mar2021_divvy_tripdata.csv')
apr_rides <- read.csv('Raw Data/Apr2021_divvy_tripdata.csv')
may_rides <- read.csv('Raw Data/May2021_divvy_tripdata.csv')
jun_rides <- read.csv('Raw Data/June2021_divvy_tripdata.csv')
jul_rides <- read.csv('Raw Data/July2021_divvy_tripdata.csv')
aug_rides <- read.csv('Raw Data/Aug2021_divvy_tripdata.csv')
sep_rides <- read.csv('Raw Data/Sept2021_divvy_tripdata.csv')
oct_rides <- read.csv('Raw Data/Oct2021_divvy_tripdata.csv')
nov_rides <- read.csv('Raw Data/Nov2021_divvy_tripdata.csv')
dec_rides <- read.csv('Raw Data/Dec2021_divvy_tripdata.csv')

#Combining all 'rides' data into a single data frame 
combined_df <- rbind(jan_rides, feb_rides, mar_rides, apr_rides, may_rides, jun_rides,
      jul_rides, aug_rides, sep_rides, oct_rides, nov_rides, dec_rides)

rm(jan_rides, feb_rides, mar_rides, apr_rides, may_rides, jun_rides,
   jul_rides, aug_rides, sep_rides, oct_rides, nov_rides, dec_rides)

#--------------DATA CLEANING

#getting a look at the structure of the data
str(combined_df)
summary(combined_df)

#reformatting some of the columns data 
  #ensuring that both 'started_at' and 'ended_at' are formatted as datetime data types
all_rides <- combined_df %>%
  mutate(started_at = as_datetime(started_at)) %>%
  mutate(ended_at = as_datetime(ended_at))

#Adding some columns to our data 
  #'ride_length_mins', 'ride_distance' (in meters), 'ride_month'
all_rides <- all_rides %>% 
  mutate(ride_length_mins = as.numeric((ended_at - started_at) / 60)) %>%
  mutate(ride_distance_m = distHaversine(cbind(start_lng, start_lat), 
                                      cbind(end_lng, end_lat))) %>%
  mutate(ride_month = month(started_at, label = TRUE)) %>%
  mutate(day_of_month = day(started_at)) %>%
  mutate(day_of_week = factor(wday(started_at))) %>%
  mutate(hour_of_day = hour(started_at))

#Missing Data
  #LOTS of missing data within the 'started_at','start_station_id', 
    #'ended_at' and 'end_station_id' and columns
  #Converting blank cell values to NA (easier to work with)
all_rides$start_station_id[all_rides$start_station_id == ''] <- NA
all_rides$end_station_id[all_rides$end_station_id == ''] <- NA
all_rides$start_station_name[all_rides$start_station_name == ''] <- NA
all_rides$end_station_name[all_rides$end_station_name == ''] <- NA

#Missing between 12 - 13% of the data for these columns
sum(is.na(all_rides$start_station_name)) / length(all_rides$start_station_name) #12.3%
sum(is.na(all_rides$end_station_name)) / length(all_rides$end_station_name) #13.2%

#creating a clean data frame with no NA values
  #lost about 12-13% of the data but we can still carry on with our analysis
all_rides_clean <- all_rides %>%
  filter(!is.na(start_station_name)) %>%
  filter(!is.na(end_station_name)) %>%
  filter(ride_distance_m > 0) %>%
  filter(ride_length_mins > 0) %>%
  arrange(started_at)

#looking at the clean data to ensure all NA values are eliminated 
View(all_rides_clean)

#--------------VISUALIZATIONS

plot <- ggplot(data = all_rides_grouped)

#Visualization #1
  #Day of week - number of rides broken out by member types 
all_rides_clean %>%
  group_by(ride_month, member_casual) %>%
  summarize(number_of_rides = n(), avg_ride_duration = mean(ride_length_mins),
            avg_ride_distance_m = mean(ride_distance_m)) %>%
  ggplot(aes(x = ride_month, y = number_of_rides, 
                                       group = member_casual, fill = member_casual)) + 
  geom_bar(position = 'dodge', stat = 'identity', width = 0.75) + 
  scale_y_continuous(labels = comma, expand = c(0,0)) + 
  theme_light() +
  labs(title = 'Cyclistic Bike-Share Rides: Jan 2021 - Dec 2021',
       subtitle = 'Total Rides by Month and Member Type') +
  theme(plot.title = element_text(face = 'bold'),
        plot.subtitle = element_text(face = 'italic')) + 
  xlab('Day of Week (Sun to Sat)') +
  ylab('Number of Rides') + 
  scale_fill_manual(values = c('#0097A7','#343e52'))

all_rides_clean %>%
  group_by(rideable_type) %>%
  summarize(mean(ride_length_mins), round(mean(ride_distance_m)))

table(all_rides_clean$member_casual, all_rides_clean$rideable_type)

all_rides_clean %>%
  group_by(member_casual) %>%
  summarize(mean(ride_length_mins), round(mean(ride_distance_m)))

table(all_rides_clean$ride_month)


#Visualization #2
#Month - number of rides broken out by member types 
all_rides_clean %>%
  group_by(ride_month, member_casual) %>%
  summarize(number_of_rides = n(), avg_ride_duration = mean(ride_length_mins),
            avg_ride_distance_m = mean(ride_distance_m)) %>%
  ggplot(aes(x = ride_month, y = number_of_rides, 
             group = member_casual, fill = member_casual)) + 
  geom_bar(position = 'dodge', stat = 'identity', width = 0.75) + 
  scale_y_continuous(labels = comma, expand = c(0,0)) + 
  theme_light() +
  labs(title = 'Cyclistic Bike-Share Rides: Jan 2021 - Dec 2021',
       subtitle = 'Total Rides per Day of Week and Member Type') +
  theme(plot.title = element_text(face = 'bold'),
        plot.subtitle = element_text(face = 'italic')) + 
  xlab('Month') +
  ylab('Number of Rides') + 
  scale_fill_manual(values = c('#0097A7','#343e52'))

all_rides_clean %>%
  group_by(day_of_week, rideable_type, member_casual) %>%
  summarize(number_of_rides = n(), avg_ride_duration = mean(ride_length_mins),
            avg_ride_distance_m = mean(ride_distance_m)) %>%
  ggplot(aes(x = rideable_type, y = avg_ride_distance_m, 
             group = member_casual, fill = member_casual)) +
  geom_bar(position = 'dodge', stat = 'identity', width = 0.75) + 
  facet_wrap(.~day_of_week) + 
  scale_y_continuous(labels = comma, expand = c(0,0)) +
  theme_light() +
  labs(title = 'Cyclistic - Avg. Ride Distance: Jan 2021 - Dec 2021',
       subtitle = "By Member and Bike Type Across Days of the Week") +
  theme(plot.title = element_text(face = 'bold'),
        plot.subtitle = element_text(face = 'italic'),
        axis.text.x = element_text(angle = -30,hjust = .20, vjust = .90)) +
  xlab('Bike Types') +
  ylab('Avg. Ride Distance (metres)') + 
  scale_fill_manual(values = c('#0097A7','#343e52'))



#--------------APPENDIX

# % of total rides by member type 
all_rides_clean %>%
  group_by(member_casual) %>%
  summarize(number_of_rides = n()) %>%
  mutate(percent_of_total = percent(number_of_rides / sum(number_of_rides)))

# % of total rides by bike type
all_rides_clean %>%
  group_by(rideable_type) %>%
  summarize(number_of_rides = n()) %>%
  mutate(percent_of_total = percent(number_of_rides / sum(number_of_rides)))
