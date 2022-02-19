library(nycflights13)
library(tidyverse)

?flights

summary(flights)
head(flights)

flights
View(flights)

# 5 Verbs for data manipulation (dplyr)
# filter()    : pick observations based on values
# arrange()   : reorder the rows
# select()    : pick variables by their names
# mutate()    : create new variables as function of existing 
# summarise() : collapse many values down to a single summary

# These verbs can be used with group_by() which changes the
# scope of each function to operate on group-by-group basis instead
# of the entire dataframe at once

# Workings of Verbs:
# 1) The first argument is the data frame
# 2) The subsequent arguments tells what to do with the dataframe
# 3) The result is a new data frame

# ---------- Filter ----------------
?dplyr::filter

# arguments are joined with & by default
(jan1 <- dplyr::filter(flights, month == 1, day == 1))
(dec25 <- dplyr::filter(flights, month == 12, day == 25))

# gives FALSE
sqrt(2) ^ 2 == 2

# using near gives TRUE
?dplyr::near
near(sqrt(2) ^ 2, 2)

# filter flights in november or december
dplyr::filter(flights, month == 11 | month == 12)

# shorthand is %in%
dplyr::filter(flights, month %in% c(11, 12))

# demorgan's law
# !(x & y) is equal to !x | !y
# !(x | y) is equal to !x & !y

# Filter flights such that their arrival or departure delay
# isn't more than two hours
# We have to find:
# !(arr_delay > 120 | dep_delay > 120)

# There are two ways:
dplyr::filter(flights, !(arr_delay > 120 | dep_delay > 120))
dplyr::filter(flights, arr_delay <= 120, dep_delay <= 120)

# determine if value is NA
# gives true
z <- NA
is.na(z)

# If we want to include missing values we ask for it
df <- dplyr::tibble(x = c(1, NA, 3))
View(df)

# filter and ask for NA
dplyr::filter(df, is.na(x) | x > 1)

# ---------------- Excersice 5.2.4 ------------------

# 1) Had an arrival delay of two hours or more
dplyr::filter(flights, arr_delay >= 120)

# 2) Flew to Houston (IAH or HOU)
dest_houston <- dplyr::filter(flights, dest %in% c("IAH", "HOU"))
View(dest_houston)

# 3) Were operated by United, American or Delta
UA_DL <- dplyr::filter(flights, carrier %in% c("AA", "UA", "DL"))
View(UA_DL)

# 4) Departed in summer (July, August, September)
summer <- dplyr::filter(flights, month %in% c(7, 8, 9))
View(summer)

# 5) Arrived more than two hours late, but didn't leave late
df <- dplyr::filter(flights, arr_delay > 120, dep_delay <= 0)
View(df)

# 6) Were delayed by at least an hour, but made up over 30 minutes in flight
df <- dplyr::filter(flights, dep_delay >= 60, dep_delay - arr_delay > 30)
View(df)

# 7) Departed between midnight and 6am (inclusive)
df <- dplyr::filter(flights, dep_time <= 600 | dep_time == 2400)
View(df)

# Find NA depature times (maybe cancelled flights)
dplyr::filter(flights, is.na(dep_time))


# ------------ Arrange ----------------
tdf <- dplyr::arrange(flights, year, month, day)
View(tdf)

# desc for arranging the rows in descending order
tdf <- dplyr::arrange(flights, dplyr::desc(dep_delay))
View(tdf)

# missing values are always sorted at the end
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

# ---------------- Excersice 5.3.1 -----------------

# 1) How could you use arrange() to sort all 
# missing values to the start? (Hint: use is.na()).

arrange(df, desc(is.na(x)), x)

# 2) Sort flights to find the most delayed flights.
# Find the flights that left earliest.

tdf <- dplyr::arrange(flights, dplyr::desc(dep_delay))
View(tdf)

tdf <- dplyr::arrange(flights, dep_delay)
View(tdf)

# 3) Find the fastest flights
View(dplyr::arrange(flights, air_time))

# 4) Flights traveled furthest and shortest
View(dplyr::arrange(flights, dplyr::desc(distance)))
View(dplyr::arrange(flights, distance))

# ----------- Select ------------------
# Narrow down on variables

dplyr::select(flights, year, month, day)

# Select columns between two columns
dplyr::select(flights, year:day)
dplyr::select(flights, -(year:day))

# 1) starts_with("abc")
# 2) ends_with("xyz")
# 3) contains("ijk")
# 4) matches("(.)\\1") regex
# 5) num_range("x", 1:3) matches x1, x2, x3

?select

# It can be used to rename columns, but then it drops
# all the columns not explicitly mentioned
# So use rename instead

dplyr::rename(flights, tail_num=tailnum)

# everything() helper can be used to move some columns to start
dplyr::select(flights, time_hour, arr_time, everything())

# What does any_of helper do?
# A: Matches variable names in a character vector but no error is thrown
vars <- c("year", "month", "day", "dep_delay")
dplyr::select(flights, any_of(vars))

# By default the selection helpers which match patterns are
# case insensitive. We change it by passing the option of FALSE
dplyr::select(flights, contains("TIME", ignore.case = FALSE))


# --------------- Mutate -------------------
# It is useful to add new columns which are functions of existing columns

# Smaller dataset with fewer variables
flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time)

?flights

# We now mutate
dplyr::mutate(flights_sml,
              gain = dep_delay - arr_delay,
              speed = distance / air_time * 60)

# We can refer to the columns we created
dplyr::mutate(flights_sml,
              gain = dep_delay - arr_delay,
              hours = air_time / 60,
              gain_per_hours = gain / hours)

# transmute drops the existing variables and keeps the new ones

# Useful creation functions
# There are functions which we can use with mutate. They must be vectorised
?flights

transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100)

# lag() and lead() allow us to refer to lagging and leading values
(x <- 1:10)
lag(x)
lead(x)

# cumulative and rolling aggregates
cumsum(x)
cummean(x)

# ranking functions ranks the data-set
min_rank(c(4, 2, 1, 34, 56, 10))


# ---------------- Excersice 5.5.2 --------------------------
# 1) Currently dep_time and sched_dep_time are convenient to look at,
# but hard to compute with because they’re not really continuous numbers.
# Convert them to a more convenient representation
# of number of minutes since midnight.

transmute(flights,
          dep_time,
          sched_dep_time,
          dt_msm = (((dep_time %/% 100) * 60 + (dep_time %% 100)) %% 1440),
          sdt_msm = ((sched_dep_time %/% 100) * 60 + (sched_dep_time %% 100)) %% 1440)

# 2) Compare air_time and arr_time - dep_time

df <- transmute(flights,
          dep_time = (((dep_time %/% 100) * 60 + (dep_time %% 100)) %% 1440),
          arr_time = ((arr_time %/% 100) * 60 + (arr_time %% 100)) %% 1440,
          air_time_diff = arr_time - dep_time)

df

# check number of non zero rows
nrow(dplyr::filter(df, air_time_diff != 0))

# 3) Compare dep_time, sched_dep_time, and dep_delay.
# How would you expect those three numbers to be related?

(df <- transmute(flights,
                dep_time = (((dep_time %/% 100) * 60 + (dep_time %% 100)) %% 1440),
                sched_dep_time = ((sched_dep_time %/% 100) * 60 + (sched_dep_time %% 100)) %% 1440,
                diff = dep_delay - (dep_time - sched_dep_time)))

# count number of rows not having 0 for difference
nrow(dplyr::filter(df, diff != 0))

# temporary tibble for diff > 0
tdf <- filter(df, diff > 0)
# plot diff and scheduled dep time to see where diff is non zero
ggplot(tdf, mapping=aes(sched_dep_time, diff)) + geom_point()


# 4) Find 10 most delayed flights using ranking function
df <- mutate(flights,
             dep_delay_min_rank = min_rank(dep_delay))
# arrange in descending order
arrange(df,
        desc(dep_delay_min_rank))


# 5) What does 1:3 + 1:10 return? Why?
(x <- 1:3 + 1:10)
# This prints the result because of 'recycling'. If longer object length is 
# multiple of shorter object length, this amounts to repeating the shorter 
# object several times. Hence this behavior with a warning because 10 is not
# a multiple of 3

# -------------- SUMMARISE ----------------------
# Collapse a dataframe to a single row
# Effective with group_by

?dplyr::summarise
?dplyr::group_by

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm=TRUE))

# Relationship between distance and average delay for each destination
?flights

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   dist = mean(distance, na.rm = TRUE),
                   arr_delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, dest != "HNL")
delay
ggplot(data = delay, mapping=aes(x = dist, y = arr_delay)) +
  geom_point(alpha = 1/3) +
  geom_smooth(se = FALSE)

# As the distance increases the arrival delay increases
# So somehow delay seems to increase for longer flights
# Hmm nice...