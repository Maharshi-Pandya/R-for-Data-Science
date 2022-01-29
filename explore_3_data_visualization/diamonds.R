library(tidyverse)

?diamonds

head(diamonds)
summary(diamonds)

?geom_bar

# bar graph for the diamonds based on cut
ggplot(data=diamonds) + 
  geom_bar(mapping=aes(x=cut))

# we see that the number of fairly cut diamonds is much less
# than the number of ideally cut diamonds

ggplot(data=diamonds) + 
  # group is a dummy variable to override the default
  # groupwise proposition
  geom_bar(mapping=aes(x=cut, y=stat(prop), group=1))

?stat_summary

ggplot(data=diamonds) +
  stat_summary(mapping=aes(x=cut, y=depth),
               fun.min = min,
               fun.max = max,
               fun = median)

?geom_pointrange

# ----------------------------------------------

ggplot(data=diamonds) +
  geom_pointrange(
    mapping=aes(x=cut, y=depth),
    stat="summary",
    fun.min=min,
    fun.max=max,
    fun=median
  )

?geom_col

ggplot(data=diamonds) +
  geom_bar(mapping=aes(x=cut, fill=clarity))

?geom_boxplot

ggplot(data=mpg, aes(x=drv, y=hwy, color=class)) +
  geom_boxplot(position = "identity")

bar <- ggplot(data=diamonds) +
  geom_bar(
    mapping=aes(x=cut, fill=cut),
    show.legend = TRUE,
    width = 1,
  ) + 
  theme(aspect.ratio = 1) +
  labs(x=NULL, y=NULL)

bar + coord_flip()
bar + coord_polar()

ggplot(data=diamonds) + 
  geom_bar(
    mapping=aes(x=cut, fill=clarity)
  ) +
  coord_polar()
