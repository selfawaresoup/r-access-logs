library(dplyr) # for data manipulation, group_by etc
library(magrittr) # for %>% operator
library(stringr)
library(ggplot2)
library(scales) # for date_format
library(forcats) # for reordering elements in a ggplot

SITE="www.selfawaresoup.com"
#SITE="dailypiano.selfawaresoup.com"
#SITE="www.aesthr.com"
#FILE="access-log-2022-08-11.csv"
FILE="merged.csv"

log <- read.csv(FILE, header=TRUE, stringsAsFactors=FALSE)

log$Date <- as.Date(log$Stamp)

filtered = log %>% filter(str_detect(Page, "/$"), HostName == SITE) %>% filter(Page != "/")

total = filtered %>% summarise(n = n())

by_date = filtered %>%
  group_by(Date) %>%
  summarise(n = n())
plot_by_date = ggplot(by_date, aes(Date, n)) +
  geom_col() +
  scale_x_date(breaks="day", labels=date_format("%b %d")) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  labs(x = "Date", y = "Requests")

plot_by_date

library(forcats)

by_page = filtered %>%
  group_by(Page) %>%
  summarise(n = n()) %>%
  arrange(desc(n))
plot_by_page <- ggplot(by_page, aes(x = fct_reorder(Page, n) %>% fct_rev(), y = n)) +
  geom_col() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  labs(x = "Page", y = "Requests")
plot_by_page



