library(dplyr)
library(magrittr)
library(stringr)
library(ggplot2)
library(forcats)

SITE="www.selfawaresoup.com"
#SITE="dailypiano.selfawaresoup.com"
#SITE="www.aesthr.com"
FILE="access-log.csv"

log <- read.csv(FILE, header=TRUE, stringsAsFactors=FALSE)

log$Date <- as.Date(log$Stamp)

filtered = log %>% filter(str_detect(Page, "/$"), HostName == SITE) %>% filter(Page != "/")

total = filtered %>% summarise(n = n())

by_date = filtered %>%
  group_by(Date) %>%
  summarise(n = n())
plot_by_date = ggplot(by_date, aes(Date, n)) +
  geom_col()

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



