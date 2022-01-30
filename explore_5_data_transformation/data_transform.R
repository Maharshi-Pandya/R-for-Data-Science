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

# 4) Flights travelled furthest and shortest
View(dplyr::arrange(flights, dplyr::desc(distance)))
View(dplyr::arrange(flights, distance))
