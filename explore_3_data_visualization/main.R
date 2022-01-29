# load package
library(tidyverse)

# mpg data-set
?mpg

# summary of the set
head(mpg)
summary(mpg)

# plot using ggplot displ vs hwy
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, color=displ > 5))

?facet_wrap

# facets rather than aesthetics
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ, y=hwy), color="red") +
  facet_wrap(vars(class), nrow=2)

?facet_grid

ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ, y=hwy), color="blue") +
  facet_grid(drv ~ .)


# smooth geom
ggplot(data=mpg) +
  geom_smooth(mapping=aes(x=displ, y=hwy))

# multiple geoms in same graph
# note mapping in ggplot func, it will treat as global mappings
ggplot(data=mpg, mapping=aes(x=displ, y=hwy, color=drv)) +
  geom_smooth(se=FALSE) +
  geom_point() # overwrite the global mappings

ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=hwy)) +
  geom_smooth(data=mpg, mapping=aes(x=displ, y=hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, group=drv), se=FALSE)

?geom_bar
