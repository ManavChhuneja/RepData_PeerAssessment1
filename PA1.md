---
title: "Reproducible Research: Peer Assessment 1"
author: "Manav Chhuneja"
date: "22/05/2020"
output: 
  html_document:
    keep_md: true
---


```r
knitr::opts_chunk$set(echo = TRUE)
dir.create("figures")
```

```
## Warning in dir.create("figures"): 'figures' already exists
```


## Loading and preprocessing the data

Initializing the packages to start with. Since I feel more at home with the readr package (included in the tidyverse package), I'll use readr function "read_csv" to load data. Printing out the first 10 rows of the activity data.


```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
```

```
## ✓ ggplot2 3.3.0     ✓ purrr   0.3.4
## ✓ tibble  3.0.1     ✓ dplyr   0.8.5
## ✓ tidyr   1.0.2     ✓ stringr 1.4.0
## ✓ readr   1.3.1     ✓ forcats 0.5.0
```

```
## ── Conflicts ────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
activity <- read_csv("~/Downloads/activity.csv")
```

```
## Parsed with column specification:
## cols(
##   steps = col_double(),
##   date = col_date(format = ""),
##   interval = col_double()
## )
```

```r
head(activity, 10)
```

```
## # A tibble: 10 x 3
##    steps date       interval
##    <dbl> <date>        <dbl>
##  1    NA 2012-10-01        0
##  2    NA 2012-10-01        5
##  3    NA 2012-10-01       10
##  4    NA 2012-10-01       15
##  5    NA 2012-10-01       20
##  6    NA 2012-10-01       25
##  7    NA 2012-10-01       30
##  8    NA 2012-10-01       35
##  9    NA 2012-10-01       40
## 10    NA 2012-10-01       45
```

I do not see any reason to process the data as it seems tidy already. However, I will process the data as the tasks ahead specify. 

## What is mean total number of steps taken per day?

### Calculate the total number of steps taken per day
For this task, I will use pipes to transform the data into the required form. Since the task asks to break down the total number of steps taken everyday, I will group the data by date and summarise it to calculate the total steps per day. Again, printing the first 10 rows of the data.


```r
total_steps <- activity %>%
        group_by(date) %>%
        summarise(total = sum(steps, na.rm = TRUE))
head(total_steps, 10)
```

```
## # A tibble: 10 x 2
##    date       total
##    <date>     <dbl>
##  1 2012-10-01     0
##  2 2012-10-02   126
##  3 2012-10-03 11352
##  4 2012-10-04 12116
##  5 2012-10-05 13294
##  6 2012-10-06 15420
##  7 2012-10-07 11015
##  8 2012-10-08     0
##  9 2012-10-09 12811
## 10 2012-10-10  9900
```

### Make a histogram of the total number of steps taken each day

Since we already have the data needed, we can create histogram fairly quickly. 


```r
hist(total_steps$total, breaks = 10, main = "Total Steps Per Day", xlab = "Total Steps")
```

![](PA1_files/figure-html/histogram of total steps each day-1.png)<!-- -->

```r
dev.copy(png,'figures/Total Steps Per Day Histogram.png')
```

```
## quartz_off_screen 
##                 3
```

```r
dev.off()
```

```
## quartz_off_screen 
##                 2
```

We can play around with the breaks arguement but for our general purposes, only 10 bins should be enough. 


### Calculate and report the mean and median of the total number of steps taken per day.

This task is fairly intuitive as well since we already have the processed data. 


```r
average <- mean(total_steps$total)
median <- median(total_steps$total)

print(paste("The Mean number of steps is: ", average))
```

```
## [1] "The Mean number of steps is:  9354.22950819672"
```

```r
print(paste("The Median number of steps is: ", median))
```

```
## [1] "The Median number of steps is:  10395"
```

## What is the average daily activity pattern?

The processing of the data is similar for this task. However, we'll group the data by intervals this time instead of the date. 

### Make a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

Now that we have the absurdly long title out of the way, we can start processing the data and plot it out. 


```r
activity %>%
        group_by(interval) %>%
        summarise(average = mean(steps, na.rm = TRUE)) %>% 
        ggplot(aes(x = interval, y = average)) +
        geom_line() +
        labs(title = "Average steps per interval", x = "Interval",
             y = "Average Steps")
```

![](PA1_files/figure-html/time series plot of average steps per interval-1.png)<!-- -->

```r
dev.copy(png,'figures/Average Steps Per Interval Time Series.png')
```

```
## quartz_off_screen 
##                 3
```

```r
dev.off()
```

```
## quartz_off_screen 
##                 2
```

This chunk of code not only transforms the data, but also plots it using the ggplot2 package (built into tidyverse).

### Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

I will use the same chunk of code from the previous task but without the plot and the data will be arranged by decending number of average steps taken per 5 minute interval. 


```r
activity %>%
        group_by(interval) %>%
        summarise(average = mean(steps, na.rm = TRUE)) %>% 
        arrange(desc(average))
```

```
## # A tibble: 288 x 2
##    interval average
##       <dbl>   <dbl>
##  1      835    206.
##  2      840    196.
##  3      850    183.
##  4      845    180.
##  5      830    177.
##  6      820    171.
##  7      855    167.
##  8      815    158.
##  9      825    155.
## 10      900    143.
## # … with 278 more rows
```

## Imputing missing values

### Calculate and report the total number of missing values in the dataset.

Calculating the number of missing values is very trivial. 


```r
sum(is.na(activity))
```

```
## [1] 2304
```

One interesting thing to note is that NAs only exist in the steps variable. My guess is that NAs represent the times when the person forgot to wear their tracker. This becomes even more conclusive because there are 0 values in the data as well which are separate from the NAs where 0 represents that the person was wearing the tracker, just not moving at all (watching tv or sleeping). 

### Devise a strategy for filling in all of the missing values in the dataset.

For this, I explored multiple options but I preferred substituting NAs with average steps taken for that time interval. For instance, if the date value of October 1, 2012 and interval value of 5 is NA, I will replace that value with the average value of the time interval 5 over all days. See and play with the code below to understand how. 

First, I will create a data set that contains the average values for all the time intervals (after removal of NAs that is.)


```r
avg_int <- activity %>%
        group_by(interval) %>%
        summarise(avg = mean(steps, na.rm = TRUE))
head(avg_int, 10)
```

```
## # A tibble: 10 x 2
##    interval    avg
##       <dbl>  <dbl>
##  1        0 1.72  
##  2        5 0.340 
##  3       10 0.132 
##  4       15 0.151 
##  5       20 0.0755
##  6       25 2.09  
##  7       30 0.528 
##  8       35 0.868 
##  9       40 0     
## 10       45 1.47
```

Now, first, I will create a copy of the original data since I do not want to edit the original data, duh. Then I will check for NAs in the steps variables and if there is an NA value, it will be replaced by the average value for that interval from the avg_int data created above. 

### Create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
data <- activity
for(x in seq_along(data$steps)){
        if(is.na(data[[x,1]])){
               index <- which(avg_int$interval == data[[x,3]])
               data[[x,1]] <- avg_int[[index, 2]]
        }
}
```

I do not like using for loops but that seemed easier to me than using apply functions. If you did it using apply, let me know how, please. 

### Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.

I will process the data created above and group it by date to calculate the mean and the median number of steps per day. 


```r
data2 <- data %>%
        group_by(date) %>%
        summarise(total = sum(steps))
head(data2, 10)
```

```
## # A tibble: 10 x 2
##    date        total
##    <date>      <dbl>
##  1 2012-10-01 10766.
##  2 2012-10-02   126 
##  3 2012-10-03 11352 
##  4 2012-10-04 12116 
##  5 2012-10-05 13294 
##  6 2012-10-06 15420 
##  7 2012-10-07 11015 
##  8 2012-10-08 10766.
##  9 2012-10-09 12811 
## 10 2012-10-10  9900
```

```r
average <- mean(data2$total)
median <- median(data2$total)

print(paste("The Mean number of steps is: ", average))
```

```
## [1] "The Mean number of steps is:  10766.1886792453"
```

```r
print(paste("The Median number of steps is: ", median))
```

```
## [1] "The Median number of steps is:  10766.1886792453"
```

Comparing these to the previous values, we can see that there's a fair difference in mean but an insignificant difference in median (will need to run a p test to test the significance though). The difference in mean is around 1412 and the difference in median is 371. One thing really interesting is that after replacing all the NAs, the data has the same median and mean. This makes me feel like the data has a normal distribution. We can confirm this by creating a histogram. 


```r
hist(data2$total, breaks = 10, main = "Total Steps Per Day", xlab = "Total Steps")
```

![](PA1_files/figure-html/Histogram after replacing NAs-1.png)<!-- -->

```r
dev.copy(png,'figures/Total Steps Per Day histogram NAs removed.png')
```

```
## quartz_off_screen 
##                 3
```

```r
dev.off()
```

```
## quartz_off_screen 
##                 2
```

We can see that there's a significant difference in the plots. As we can see, the NAs in the intiail histogram were percieved as 0's so there was a peak at 0 steps. Now, since we have replaced the NAs, we do not have that peak, making the distribution closer to a normal distribution. 


## Are there differences in activity patterns between weekdays and weekends?

### Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

Again, I will use the pipes to create another column into the existing data set that has a value of weekend if the dat is Saturday or Sunday and Weekdays otherwise. This has to be done using the data we got after replacing the NAs. We'll group the data by the week (whether it's a weekday or a weekend) and the interval variable, in opposite order. 


```r
data3 <- data %>%
        mutate(week = as.factor(ifelse(weekdays(data$date) %in% c("Saturday", "Sunday"), 
                               yes = "Weekend", no = "Weekday"))) %>%
        group_by(interval, week) %>%
        summarise(avg = mean(steps)) 
head(data3, 10)
```

```
## # A tibble: 10 x 3
## # Groups:   interval [5]
##    interval week        avg
##       <dbl> <fct>     <dbl>
##  1        0 Weekday 2.25   
##  2        0 Weekend 0.215  
##  3        5 Weekday 0.445  
##  4        5 Weekend 0.0425 
##  5       10 Weekday 0.173  
##  6       10 Weekend 0.0165 
##  7       15 Weekday 0.198  
##  8       15 Weekend 0.0189 
##  9       20 Weekday 0.0990 
## 10       20 Weekend 0.00943
```


### Make a panel plot containing a time series plot of the 5-minute interval and the average number of steps taken, averaged across all weekday days or weekend days. 

I will complete this final task using the ggplot2 functions. 


```r
ggplot(data3, aes(x = interval, y = avg)) +
        geom_line() +
        facet_wrap(.~week) +
        labs(title = "Average Steps Per Interval During Weekdays vs Weekends",
             x = "Interval",
             y = "Average Steps")
```

![](PA1_files/figure-html/Weekday vs weekend average steps per interval-1.png)<!-- -->

```r
dev.copy(png,'figures/Time Series Plot Weekday vs Weekend.png')
```

```
## quartz_off_screen 
##                 3
```

```r
dev.off()
```

```
## quartz_off_screen 
##                 2
```

It's not an exact copy of the plot provided but for our intents and purposes, it still works. 
