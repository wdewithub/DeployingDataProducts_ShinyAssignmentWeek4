---
title       : Ozone calculator pitch
subtitle    : 
author      : Wendy De Wit
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
github:
  user: wdewithub
  repo: DeployingDataProducts_ShinyAssignmentWeek4
--- .class #id


## The fundaments of my ozone calculator

The ozone calculator was built using the airquality dataset in R. The airquality dataset has daily observations on:

1. ozone concentration (in ppb)
2. wind speed (in mph)
3. temperature (in Fahrenheit)
4. solar radiation (in lang)

measured in New York between May 1, 1973 and September 30, 1973.

We fitted a linear regression model predicting the ozone concentration dependent on the 3 other weather elements. This model could then be used to predict ozone concentration given user input on wind, temperature and solar radiation. 

However, as information on expected solar radiation might be difficult to find, we also fitted a second linear model predicting solar radiation depending on the month and temperature. This way a user can simply specifiy the month, wind speed and temperature and still get an estimate about the expected ozone concentration.

---

## Predicting solar radiation from temperature and month






```r
solarfit <- with(completed_airqual,lm(Solar.R~Temp+Month))
solarfit
```

```
## 
## Call:
## lm(formula = Solar.R ~ Temp + Month)
## 
## Coefficients:
## (Intercept)         Temp        Month  
##      50.011        3.057      -14.452
```

---

## Predicting ozone from wind, temperature and month


```r
modelFit <- with(completed_airqual,lm(log(Ozone)~ Temp+Solar.R+Wind))
modelFit
```

```
## 
## Call:
## lm(formula = log(Ozone) ~ Temp + Solar.R + Wind)
## 
## Coefficients:
## (Intercept)         Temp      Solar.R         Wind  
##   -0.269940     0.048627     0.002267    -0.048949
```

---

## Evaluating the ozone prediction

The predicted ozone concentration is also evaluated on its impact on human health:

1. green: < 100 ppb, safe ozone level
2. yellow: 100-500 ppb, ozone level with minor health risks (eye, nose, throat irritation, shortness of breatch)
3. orange: 500-1000 ppb, ozone level with strong health risks (breathing disorders, chest pain, dry cough, severe fatigue)
4. red: > 1000 ppb, ozone level with severe health risks (severe pneumonia, headache, ...)

### Enjoy playing around with the calculator and keep an eye on the ozone level in your neighbourhood ! ###
