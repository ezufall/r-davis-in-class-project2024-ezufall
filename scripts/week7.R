library(tidyverse)
library(ggplot2)

#Section 1: Plot Best Practices and GGPlot Review####
#ggplot has four parts:
#data / materials   ggplot(data=yourdata)
#plot type / design   geom_...
#aesthetics / decor   aes()
#stats / wiring   stat_...

#Let's see what this looks like:

#Here we practice creating a dot plot of price on carat
ggplot(diamonds, aes(x= carat, y= price)) +
  geom_point()


#Remember from Part 1 how we iterate? 
#I've added transparency and color

#all-over color
ggplot(diamonds, aes(x= carat, y= price)) +
  geom_point(color="blue")
#color by variable
ggplot(diamonds, aes(x= carat, y= price, color=clarity)) +
  geom_point(alpha = 0.2)

#plot best practices:
#remove backgrounds, redundant labels, borders, reduce colors and special effects, 
#remove bolding, lighten labels, remove lines, direct label

#Now I've removed the background to clean up the plot
#As we learned last week, there are other themes besides classic. Play around!
ggplot(diamonds, aes(x= carat, y= price, color=clarity)) +
  geom_point(alpha = 0.2) + theme_classic()

#keep your visualization simple with a clear message
#label axes
#start axes at zero

#Now I've added a title and edited the y label to be more specific
ggplot(diamonds, aes(x= carat, y= price, color=clarity)) +
  geom_point(alpha = 0.2) + theme_classic() + 
  ggtitle("Price by Diamond Quality") + ylab("price in $")

#Now I've added linear regression trendlines for each color
ggplot(diamonds, aes(x= carat, y= price, color=clarity)) +
  geom_point(alpha = 0.2) + theme_classic() + 
  ggtitle("Price by Diamond Quality") + ylab("price in $") + 
  stat_smooth(method = "lm")

#Now I've instead added LOESS trendcurves for each color
ggplot(diamonds, aes(x= carat, y= price, color=clarity)) +
  geom_point(alpha = 0.2) + theme_classic() + 
  ggtitle("Price by Diamond Quality") + ylab("price in $") + 
  stat_smooth(method = "loess")

#Go to the Dataviz course materials part 1 for a refresher on how to use
#colors in geom_line (a time series)

#Section 2 Color Palette Choices and Color-Blind Friendly Visualizations ####

#always work to use colorblind-friendly or black-and-white friendly palettes

#Be sure to read this superb article!
#https://www.nature.com/articles/s41467-020-19160-7?utm_source=twitter&utm_medium=social&utm_content=organic&utm_campaign=NGMT_USG_JC01_GL_NRJournals

#I use the colorpalette knowledge I learned from R-DAVIS every time I make a plot,
#and it's not an exaggeration to say that it changed my life!
#Here are some templates that you may use and edit in your own work.

#DISCRETE/CATEGORICAL

#From the ggthemes package:
library(ggthemes)
ggplot(diamonds, aes(x= carat, y= price, color=clarity)) +
  geom_point(alpha = 1) + theme_classic() + 
  ggtitle("Price by Diamond Quality") + ylab("price in $") + 
scale_color_colorblind("clarity")

#scale_color is for the outline
ggplot(diamonds, aes(x= cut, y= carat, color = color)) +
  geom_boxplot(alpha = 0.2) + theme_classic() + 
  ggtitle("Diamond Quality by Cut") + 
  scale_color_colorblind("color")

#scale_fill is for the fill. note I have to change the
#aes parameter from "color =" to "fill ="
ggplot(diamonds, aes(x= cut, y= carat, fill = color)) +
  geom_boxplot() + theme_classic() + 
  ggtitle("Diamond Quality by Cut") + 
  scale_fill_colorblind("color")

#Manual Palette Design
#this is another version of the same 
#colorblind palette from the ggthemes package but with gray instead of black.
#This is an example of how to create a named vector
#of colors and use it as a manual fill.
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
names(cbPalette) <- levels(diamonds$color)
#we don't need all the colors in the palette because there are only 7 categories. 
#We cut the vector length to 7 here
cbPalette <- cbPalette[1:length(levels(diamonds$color))]

ggplot(diamonds, aes(x= cut, y= carat, fill = color)) +
  geom_boxplot() + theme_classic() + 
  ggtitle("Diamond Quality by Cut") + 
  scale_fill_manual(values = cbPalette)

#Paul Tol also has developed discrete/categorical colorblind palettes:
#https://cran.r-project.org/web/packages/khroma/vignettes/tol.html
#you can enter the hex codes in manually just like the cbPalette example above

#From RColorBrewer -- this is a list of all the colorblind friendly discrete color palettes
#There are three types: 
#1: sequential (for plotting least to most of something, with zero at one end)
#2: qualitative (for showing different categories)
#3: diverging (for plotting a range from negative values to positive values, with zero in the middle)
library("RColorBrewer")
display.brewer.all(colorblindFriendly = TRUE)

#Let's pick a sequential one first:
ggplot(diamonds, aes(x= cut, y= carat, fill = color)) +
  geom_boxplot() + theme_classic() + 
  ggtitle("Diamond Quality by Cut") + 
  scale_fill_brewer(palette = "YlOrRd")

#Now a categorical one:
ggplot(head(cbind(mtcars,model=rownames(mtcars))), 
       aes(x= wt, y= mpg, color = model)) +
  geom_point(shape=24, fill="gray") + theme_classic() + 
  ggtitle("Efficiency of Cars") + 
  scale_color_brewer(palette = "Set2")

#you can use the viridis palettes for ordered categorical data
#use scale_fill_viridis_d or scale_color_viridis_d for discrete data
ggplot(diamonds, aes(x = clarity, fill = cut)) + 
  geom_bar() +
  theme(axis.text.x = element_text(angle=70, vjust=0.5)) +
  scale_fill_viridis_d(option = "B") +
  theme_classic()

#CONTINUOUS DATA
#use scale_fill_viridis_c or scale_color_viridis_c for continuous
#I set direction = -1 to reverse the direction of the colorscale.
ggplot(diamonds, aes(x= clarity, y= carat, color=price)) +
  geom_point(alpha = 0.2) + theme_classic() +
  scale_color_viridis_c(option = "C", direction = 1)

#let's pick another viridis color scheme by using a different letter for option
ggplot(diamonds, aes(x= clarity, y= carat, color=price)) +
  geom_point(alpha = 0.2) + theme_classic() +
  scale_color_viridis_c(option = "E", direction = -1)
  


#also check out the turbo color palette!
#https://docs.google.com/presentation/d/1Za8JHhvr2xD93V0bqfK--Y9GnWL1zUrtvxd_y9a2Wo8/edit?usp=sharing
#https://blog.research.google/2019/08/turbo-improved-rainbow-colormap-for.html

#to download it and use it in R, use this link
#https://rdrr.io/github/jlmelville/vizier/man/turbo.html


#Section 3: Non-visual representations ####
#Braille package
mybarplot <- ggplot(diamonds, aes(x = clarity)) + 
  geom_bar() +
  theme(axis.text.x = element_text(angle=70, vjust=0.5)) +
  theme_classic() + ggtitle("Number of Diamonds by Clarity")
mybarplot

library(BrailleR)

VI(mybarplot)

library(sonify)
plot(iris$Petal.Width)
sonify(iris$Petal.Width)

detach("package:BrailleR", unload=TRUE)

#Section 4: Publishing Plots and Saving Figures & Plots ####
library(cowplot)
#you can print multiple plots together, which is helpful for publications
# make a few plots:
plot.diamonds <- ggplot(diamonds, aes(clarity, fill = cut)) + 
  geom_bar() +
  theme(axis.text.x = element_text(angle=70, vjust=0.5))
#plot.diamonds

plot.cars <- ggplot(mpg, aes(x = cty, y = hwy, colour = factor(cyl))) + 
  geom_point(size = 2.5)
#plot.cars

plot.iris <- ggplot(data=iris, aes(x=Sepal.Length, y=Petal.Length, fill=Species)) +
  geom_point(size=3, alpha=0.7, shape=21)
#plot.iris

# use plot_grid
panel_plot <- plot_grid(plot.cars, plot.iris, plot.diamonds, 
                        labels=c("A", "B", "C"), ncol=2, nrow = 2)

panel_plot

#you can fix the sizes for more control over the result
fixed_gridplot <- ggdraw() + draw_plot(plot.iris, x = 0, y = 0, width = 1, height = 0.5) +
  draw_plot(plot.cars, x=0, y=.5, width=0.5, height = 0.5) +
  draw_plot(plot.diamonds, x=0.5, y=0.5, width=0.5, height = 0.5) + 
  draw_plot_label(label = c("A","B","C"), x = c(0, 0.5, 0), y = c(1, 1, 0.5))

fixed_gridplot

#saving figures
ggsave("figures/gridplot.png", fixed_gridplot)
#you can save images as .png, .jpeg, .tiff, .pdf, .bmp, or .svg

#for publications, use dpi of at least 700
ggsave("figures/gridplot.png", fixed_gridplot, 
       width = 6, height = 4, units = "in", dpi = 700)

#interactive web applications
library(plotly)

plot.iris <- ggplot(data=iris, aes(x=Sepal.Length, y=Petal.Length, fill=Species)) +
  geom_point(size=3, alpha=0.7, shape=21)

plotly::ggplotly(plot.iris)
