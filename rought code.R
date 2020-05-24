library(readr)
library(tidyverse)
activity <- read_csv("~/Downloads/activity.csv")
View(activity)


total_steps <- activity %>%
        group_by(date) %>%
        summarise(total = sum(steps, na.rm = TRUE))

hist(total_steps$total, breaks = 5)



# ------------------------------------------------------------------------------

activity %>%
        group_by(interval) %>%
        summarise(average = mean(steps, na.rm = TRUE)) %>% 
        ggplot(aes(x = interval, y = average)) +
        geom_line()

activity %>%
        group_by(interval, date) %>%
        summarise(average = mean(steps)) %>% 
        arrange(desc(average))

# ------------------------------------------------------------------------------

sum(is.na(activity))


avg_int <- activity %>%
        group_by(interval) %>%
        summarise(avg = mean(steps, na.rm = TRUE))

data <- activity

for(x in seq_along(data$steps)){
        if(is.na(data[[x,1]])){
               index <- which(avg_int$interval == data[[x,3]])
               data[[x,1]] <- avg_int[[index, 2]]
        }
}


data2 <- data %>%
        group_by(date) %>%
        summarise(total = sum(steps), 
                  avg = mean(steps),
                  med = median(steps))

hist(data2$total)


# ------------------------------------------------------------------------------



data3 <- data %>%
        mutate(week = as.factor(ifelse(weekdays(data$date) %in% c("Saturday", "Sunday"), 
                               yes = "Weekend", no = "Weekday"))) %>%
        group_by(interval, week) %>%
        summarise(avg = mean(steps)) 


ggplot(data3, aes(x = interval, y = avg)) +
        geom_line() +
        facet_wrap(.~week)
