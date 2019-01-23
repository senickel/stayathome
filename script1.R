library(tidyverse)
library(readstata13)
library(survey)
options(stringsAsFactors = FALSE)

dat <- read.dta13("ZA5900_v4-0-0.dta",convert.factors = FALSE)

d1 <- svydesign(ids=~1,data=dat,weights=dat$WEIGHT)


df1 <- svytable(~V4+V12,d1) %>% 
  as.data.frame()
head(df1)
df2 <- lapply(df1$V4 %>% unique,function(x) {
  x1 <- df1 %>% 
    filter(V4==x)
  x1 %>% 
    mutate(Prob = Freq/sum(x1$Freq))
}) %>% 
  do.call(rbind,.) %>% 
  apply(2,as.numeric) %>% 
  as.data.frame()


df3 <- data.frame(country = c("Austria","Denmark","Germany","Sweden","United Kingdom","USA"),
           code = c(40,208,276,752,826,840),
           predicted = c(.51,.21,.61,.27,.44,.31))


df4 <- left_join(df3,df2,by=c("code" = "V4")) %>% 
  filter(V12==3) 

ct <- cor.test(df4$predicted_penalty,df4$stay_at_home)

df4 %>% 
  ggplot(aes(x=stay_at_home,y=predicted_penalty)) +
  geom_point() +
  geom_text(aes(label=country),nudge_x = 0.025,nudge_y = -0.01) +
  theme_classic() + 
  scale_x_continuous(name = "Women with Children Under School Age Should Stay at Home\n(Fraction Agreeing)",
                     limits = c(0,max(df4$Prob)+0.025)) + 
  scale_y_continuous(name = "Long-Run Child Penality in Earnings (Eyeballed from Graph)",
                     limits = c(0,max(df4$predicted))) +
  stat_smooth(formula = y ~ x, method="lm", data = df4,se=FALSE) +
  geom_text(aes(x = 0.4,y = 0.1,
                label = paste0("Slope: ",round(ct$estimate,2)," (",round(ct$p.value,2),")")))


