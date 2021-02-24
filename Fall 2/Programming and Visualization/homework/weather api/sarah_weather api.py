#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pprint 
import requests 
import numpy as np
import pandas as pd
import re
import statistics
import datetime


# In[2]:


#Create list for cities
cities = ['Anchorage,USA','Buenos+Aires,Argentina','Sao+Jose+dos+Campos,Brazil' ,'San+Jose,CostaRica' ,'Nanaimo,Canada', 'Ningbo,China','Giza,Egypt','Mannheim,Germany', 'Hyderabad,India','Tehran,Iran','Bishkek,Kyrgyzstan','Riga,Latvia','Quetta,Pakistan','Warsaw,Poland','Dhahran,SaudiaArabia','Madrid,Spain','Oldham,England']


# In[3]:


#Personalized API key
api_key = 'b53aceaf802b2fa08ca57cb8531e8592'
#Pull data from API
def forecast(city):
    response=requests.get('https://api.openweathermap.org/data/2.5/forecast?q=' + city +'&units=metric&appid=' + api_key)
    return response.json()


# In[4]:


#Create Weather Dictionary
weather_dict={}
#Loop data for specific cities into weather_dict
for city in cities:
    weather_dict[city]=forecast(city)


# In[5]:


#Create data frame
df = pd.DataFrame(index = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17] ,columns = ['City' , 'Min 1' , 'Max 1' , 'Min 2' , 'Max 2' , 'Min 3' , 'Max 3' , 'Min 4' , 'Max 4' , 'Min 5' , 'Max 5' , 'Min Avg' , 'Max Avg'])
#Populate City Names
df.loc[1]["City"]="Anchorage, USA"
df.loc[2]["City"]="Buenos Aires, Argentina"
df.loc[3]["City"]="São José dos Campos, Brazil"
df.loc[4]["City"]="San José, Costa Rica"
df.loc[5]["City"]="Nanaimo, Canada"
df.loc[6]["City"]="Ningbo, China"
df.loc[7]["City"]="Giza, Egypt"
df.loc[8]["City"]="Mannheim, Germany"
df.loc[9]["City"]="Hyderabad, India"
df.loc[10]["City"]="Tehran, Iran"
df.loc[11]["City"]="Bishkek, Kyrgyzstan"
df.loc[12]["City"]="Riga, Latvia"
df.loc[13]["City"]="Quetta, Pakistan"
df.loc[14]["City"]="Warsaw, Poland"
df.loc[15]["City"]="Dhahran, Saudia Arabia"
df.loc[16]["City"]="Madrid, Spain"
df.loc[17]["City"]="Oldham, England"


# In[6]:


#USA
#Create list of times
USADATE=[]
for x in weather_dict['Anchorage,USA']['list']:
    USADATE.append(x['dt_txt'])
    
#Make it list of just the day
USADAY=[]
for x in USADATE:
    USADAY.append(int(x[8:10]))
    
#List of min and max temps
USAMIN=[]
USAMAX=[]
for hi in range(0, 40):
    USAMIN.append(weather_dict["Anchorage,USA"]["list"][hi]['main']['temp_min'])
    USAMAX.append(weather_dict["Anchorage,USA"]["list"][hi]['main']['temp_max'])
#Write everything to a mega list
USA=[]
USA=[USADAY, USAMIN, USAMAX]

#Throw it in a dataframe
USA=pd.DataFrame(USA).transpose()
#Name the columns
USA.columns=["Date", "Min" , "Max"]

#Let's see it
USA


# In[7]:


#Create variables for each day
Today = USA.loc[0]["Date"]
Day1=Today+1
Day2=Today+2
Day3=Today+3
Day4=Today+4
Day5=Today+5


# In[8]:


USAMINS=USA.groupby(["Date"])["Min"].min()
USAMAXS=USA.groupby(["Date"])["Max"].max()


# In[9]:


df.loc[1]["Max 1"]=USAMAXS.loc[Day1]
df.loc[1]["Max 2"]=USAMAXS.loc[Day2]
df.loc[1]["Max 3"]=USAMAXS.loc[Day3]
df.loc[1]["Max 4"]=USAMAXS.loc[Day4]
df.loc[1]["Max 5"]=USAMAXS.loc[Day5]

df.loc[1]["Min 1"]=USAMINS.loc[Day1]
df.loc[1]["Min 2"]=USAMINS.loc[Day2]
df.loc[1]["Min 3"]=USAMINS.loc[Day3]
df.loc[1]["Min 4"]=USAMINS.loc[Day4]
df.loc[1]["Min 5"]=USAMINS.loc[Day5]


# In[10]:


#ARG
#Create list of times
ARGDATE=[]
for x in weather_dict['Buenos+Aires,Argentina']['list']:
    ARGDATE.append(x['dt_txt'])
#Make it list of just the day
ARGDAY=[]
for x in ARGDATE:
	ARGDAY.append(int(x[8:10]))

#List of min and max temps
ARGMIN=[]
ARGMAX=[]
for hi in range(0, 40):
    ARGMIN.append(weather_dict['Buenos+Aires,Argentina']["list"][hi]['main']['temp_min'])
    ARGMAX.append(weather_dict['Buenos+Aires,Argentina']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
ARG=[]
ARG=[ARGDAY, ARGMIN, ARGMAX]

#Throw it in a dataframe
ARG=pd.DataFrame(ARG).transpose()
#Name the columns
ARG.columns=["Date", "Min" , "Max"]

#Let's see it
ARG

#Group by date
ARGMINS=ARG.groupby(["Date"])["Min"].min()
ARGMAXS=ARG.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[2]["Max 1"]=ARGMAXS.loc[Day1]
df.loc[2]["Max 2"]=ARGMAXS.loc[Day2]
df.loc[2]["Max 3"]=ARGMAXS.loc[Day3]
df.loc[2]["Max 4"]=ARGMAXS.loc[Day4]
df.loc[2]["Max 5"]=ARGMAXS.loc[Day5]

df.loc[2]["Min 1"]=ARGMINS.loc[Day1]
df.loc[2]["Min 2"]=ARGMINS.loc[Day2]
df.loc[2]["Min 3"]=ARGMINS.loc[Day3]
df.loc[2]["Min 4"]=ARGMINS.loc[Day4]
df.loc[2]["Min 5"]=ARGMINS.loc[Day5]


# In[11]:


#BRA
#Create list of times
BRADATE=[]
for x in weather_dict['Sao+Jose+dos+Campos,Brazil']['list']:
    BRADATE.append(x['dt_txt'])
    
#Make it list of just the day
BRADAY=[]
for x in BRADATE:
    BRADAY.append(int(x[8:10]))
#List of min and max temps
BRAMIN=[]
BRAMAX=[]
for hi in range(0, 40):
    BRAMIN.append(weather_dict['Sao+Jose+dos+Campos,Brazil']["list"][hi]['main']['temp_min'])
    BRAMAX.append(weather_dict['Sao+Jose+dos+Campos,Brazil']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
BRA=[]
BRA=[BRADAY, BRAMIN, BRAMAX]

#Throw it in a dataframe
BRA=pd.DataFrame(BRA).transpose()
#Name the columns
BRA.columns=["Date", "Min" , "Max"]

#Let's see it
BRA

#Group by date
BRAMINS=BRA.groupby(["Date"])["Min"].min()
BRAMAXS=BRA.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[3]["Max 1"]=BRAMAXS.loc[Day1]
df.loc[3]["Max 2"]=BRAMAXS.loc[Day2]
df.loc[3]["Max 3"]=BRAMAXS.loc[Day3]
df.loc[3]["Max 4"]=BRAMAXS.loc[Day4]
df.loc[3]["Max 5"]=BRAMAXS.loc[Day5]

df.loc[3]["Min 1"]=BRAMINS.loc[Day1]
df.loc[3]["Min 2"]=BRAMINS.loc[Day2]
df.loc[3]["Min 3"]=BRAMINS.loc[Day3]
df.loc[3]["Min 4"]=BRAMINS.loc[Day4]
df.loc[3]["Min 5"]=BRAMINS.loc[Day5]


# In[12]:


#COS
#Create list of times
COSDATE=[]
for x in weather_dict['San+Jose,CostaRica']['list']:
    COSDATE.append(x['dt_txt'])
#Make it list of just the day
COSDAY=[]
for x in COSDATE:
    COSDAY.append(int(x[8:10]))
#List of min and max temps
COSMIN=[]
COSMAX=[]
for hi in range(0, 40):
    COSMIN.append(weather_dict['San+Jose,CostaRica']["list"][hi]['main']['temp_min'])
    COSMAX.append(weather_dict['San+Jose,CostaRica']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
COS=[]
COS=[COSDAY, COSMIN, COSMAX]

#Throw it in a dataframe
COS=pd.DataFrame(COS).transpose()
#Name the columns
COS.columns=["Date", "Min" , "Max"]

#Let's see it
COS

#Group by date
COSMINS=COS.groupby(["Date"])["Min"].min()
COSMAXS=COS.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[4]["Max 1"]=COSMAXS.loc[Day1]
df.loc[4]["Max 2"]=COSMAXS.loc[Day2]
df.loc[4]["Max 3"]=COSMAXS.loc[Day3]
df.loc[4]["Max 4"]=COSMAXS.loc[Day4]
df.loc[4]["Max 5"]=COSMAXS.loc[Day5]

df.loc[4]["Min 1"]=COSMINS.loc[Day1]
df.loc[4]["Min 2"]=COSMINS.loc[Day2]
df.loc[4]["Min 3"]=COSMINS.loc[Day3]
df.loc[4]["Min 4"]=COSMINS.loc[Day4]
df.loc[4]["Min 5"]=COSMINS.loc[Day5]


# In[13]:


#CAN
#Create list of times
CANDATE=[]
for x in weather_dict['Nanaimo,Canada']['list']:
    CANDATE.append(x['dt_txt'])
    
#Make it list of just the day
CANDAY=[]
for x in CANDATE:
    CANDAY.append(int(x[8:10]))
#List of min and max temps
CANMIN=[]
CANMAX=[]
for hi in range(0, 40):
    CANMIN.append(weather_dict['Nanaimo,Canada']["list"][hi]['main']['temp_min'])
    CANMAX.append(weather_dict['Nanaimo,Canada']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
CAN=[]
CAN=[CANDAY, CANMIN, CANMAX]

#Throw it in a dataframe
CAN=pd.DataFrame(CAN).transpose()
#Name the columns
CAN.columns=["Date", "Min" , "Max"]

#Let's see it
CAN

#Group by date
CANMINS=CAN.groupby(["Date"])["Min"].min()
CANMAXS=CAN.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[5]["Max 1"]=CANMAXS.loc[Day1]
df.loc[5]["Max 2"]=CANMAXS.loc[Day2]
df.loc[5]["Max 3"]=CANMAXS.loc[Day3]
df.loc[5]["Max 4"]=CANMAXS.loc[Day4]
df.loc[5]["Max 5"]=CANMAXS.loc[Day5]

df.loc[5]["Min 1"]=CANMINS.loc[Day1]
df.loc[5]["Min 2"]=CANMINS.loc[Day2]
df.loc[5]["Min 3"]=CANMINS.loc[Day3]
df.loc[5]["Min 4"]=CANMINS.loc[Day4]
df.loc[5]["Min 5"]=CANMINS.loc[Day5]


# In[14]:


#CHI
#Create list of times
CHIDATE=[]
for x in weather_dict['Ningbo,China']['list']:
    CHIDATE.append(x['dt_txt'])
    
#Make it list of just the day
CHIDAY=[]
for x in CHIDATE:
    CHIDAY.append(int(x[8:10]))
#List of min and max temps
CHIMIN=[]
CHIMAX=[]
for hi in range(0, 40):
    CHIMIN.append(weather_dict['Ningbo,China']["list"][hi]['main']['temp_min'])
    CHIMAX.append(weather_dict['Ningbo,China']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
CHI=[]
CHI=[CHIDAY, CHIMIN, CHIMAX]

#Throw it in a dataframe
CHI=pd.DataFrame(CHI).transpose()
#Name the columns
CHI.columns=["Date", "Min" , "Max"]

#Let's see it
CHI

#Group by date
CHIMINS=CHI.groupby(["Date"])["Min"].min()
CHIMAXS=CHI.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[6]["Max 1"]=CHIMAXS.loc[Day1]
df.loc[6]["Max 2"]=CHIMAXS.loc[Day2]
df.loc[6]["Max 3"]=CHIMAXS.loc[Day3]
df.loc[6]["Max 4"]=CHIMAXS.loc[Day4]
df.loc[6]["Max 5"]=CHIMAXS.loc[Day5]

df.loc[6]["Min 1"]=CHIMINS.loc[Day1]
df.loc[6]["Min 2"]=CHIMINS.loc[Day2]
df.loc[6]["Min 3"]=CHIMINS.loc[Day3]
df.loc[6]["Min 4"]=CHIMINS.loc[Day4]
df.loc[6]["Min 5"]=CHIMINS.loc[Day5]


# In[15]:


#EGY
#Create list of times
EGYDATE=[]
for x in weather_dict['Giza,Egypt']['list']:
    EGYDATE.append(x['dt_txt'])
    
#Make it list of just the day
EGYDAY=[]
for x in EGYDATE:
    EGYDAY.append(int(x[8:10]))
#List of min and max temps
EGYMIN=[]
EGYMAX=[]
for hi in range(0, 40):
    EGYMIN.append(weather_dict['Giza,Egypt']["list"][hi]['main']['temp_min'])
    EGYMAX.append(weather_dict['Giza,Egypt']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
EGY=[]
EGY=[EGYDAY, EGYMIN, EGYMAX]

#Throw it in a dataframe
EGY=pd.DataFrame(EGY).transpose()
#Name the columns
EGY.columns=["Date", "Min" , "Max"]

#Let's see it
EGY

#Group by date
EGYMINS=EGY.groupby(["Date"])["Min"].min()
EGYMAXS=EGY.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[7]["Max 1"]=EGYMAXS.loc[Day1]
df.loc[7]["Max 2"]=EGYMAXS.loc[Day2]
df.loc[7]["Max 3"]=EGYMAXS.loc[Day3]
df.loc[7]["Max 4"]=EGYMAXS.loc[Day4]
df.loc[7]["Max 5"]=EGYMAXS.loc[Day5]

df.loc[7]["Min 1"]=EGYMINS.loc[Day1]
df.loc[7]["Min 2"]=EGYMINS.loc[Day2]
df.loc[7]["Min 3"]=EGYMINS.loc[Day3]
df.loc[7]["Min 4"]=EGYMINS.loc[Day4]
df.loc[7]["Min 5"]=EGYMINS.loc[Day5]


# In[16]:


#GER
#Create list of times
GERDATE=[]
for x in weather_dict['Mannheim,Germany']['list']:
        GERDATE.append(x['dt_txt'])
        
#Make it list of just the day
GERDAY=[]
for x in GERDATE:
    GERDAY.append(int(x[8:10]))
    
#List of min and max temps
GERMIN=[]
GERMAX=[]
for hi in range(0, 40):
    GERMIN.append(weather_dict['Mannheim,Germany']["list"][hi]['main']['temp_min'])
    GERMAX.append(weather_dict['Mannheim,Germany']["list"][hi]['main']['temp_max'])

    #Write everything to a mega list
GER=[]
GER=[GERDAY, GERMIN, GERMAX]

#Throw it in a dataframe
GER=pd.DataFrame(GER).transpose()
#Name the columns
GER.columns=["Date", "Min" , "Max"]

#Let's see it
GER

#Group by date
GERMINS=GER.groupby(["Date"])["Min"].min()
GERMAXS=GER.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[8]["Max 1"]=GERMAXS.loc[Day1]
df.loc[8]["Max 2"]=GERMAXS.loc[Day2]
df.loc[8]["Max 3"]=GERMAXS.loc[Day3]
df.loc[8]["Max 4"]=GERMAXS.loc[Day4]
df.loc[8]["Max 5"]=GERMAXS.loc[Day5]

df.loc[8]["Min 1"]=GERMINS.loc[Day1]
df.loc[8]["Min 2"]=GERMINS.loc[Day2]
df.loc[8]["Min 3"]=GERMINS.loc[Day3]
df.loc[8]["Min 4"]=GERMINS.loc[Day4]
df.loc[8]["Min 5"]=GERMINS.loc[Day5]


# In[17]:


#IND
#Create list of times
INDDATE=[]
for x in weather_dict['Hyderabad,India']['list']:
    INDDATE.append(x['dt_txt'])
    
#Make it list of just the day
INDDAY=[]
for x in INDDATE:
    INDDAY.append(int(x[8:10]))
#List of min and max temps
INDMIN=[]
INDMAX=[]
for hi in range(0, 40):
    INDMIN.append(weather_dict['Hyderabad,India']["list"][hi]['main']['temp_min'])
    INDMAX.append(weather_dict['Hyderabad,India']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
IND=[]
IND=[INDDAY, INDMIN, INDMAX]

#Throw it in a dataframe
IND=pd.DataFrame(IND).transpose()
#Name the columns
IND.columns=["Date", "Min" , "Max"]

#Let's see it
IND

#Group by date
INDMINS=IND.groupby(["Date"])["Min"].min()
INDMAXS=IND.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[9]["Max 1"]=INDMAXS.loc[Day1]
df.loc[9]["Max 2"]=INDMAXS.loc[Day2]
df.loc[9]["Max 3"]=INDMAXS.loc[Day3]
df.loc[9]["Max 4"]=INDMAXS.loc[Day4]
df.loc[9]["Max 5"]=INDMAXS.loc[Day5]

df.loc[9]["Min 1"]=INDMINS.loc[Day1]
df.loc[9]["Min 2"]=INDMINS.loc[Day2]
df.loc[9]["Min 3"]=INDMINS.loc[Day3]
df.loc[9]["Min 4"]=INDMINS.loc[Day4]
df.loc[9]["Min 5"]=INDMINS.loc[Day5]


# In[18]:


#IRA
#Create list of times
IRADATE=[]
for x in weather_dict['Tehran,Iran']['list']:
        IRADATE.append(x['dt_txt'])
    
#Make it list of just the day
IRADAY=[]
for x in IRADATE:
    IRADAY.append(int(x[8:10]))
#List of min and max temps
IRAMIN=[]
IRAMAX=[]
for hi in range(0, 40):
    IRAMIN.append(weather_dict['Tehran,Iran']["list"][hi]['main']['temp_min'])
    IRAMAX.append(weather_dict['Tehran,Iran']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
IRA=[]
IRA=[IRADAY, IRAMIN, IRAMAX]

#Throw it in a dataframe
IRA=pd.DataFrame(IRA).transpose()
#Name the columns
IRA.columns=["Date", "Min" , "Max"]

#Let's see it
IRA

#Group by date
IRAMINS=IRA.groupby(["Date"])["Min"].min()
IRAMAXS=IRA.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[10]["Max 1"]=IRAMAXS.loc[Day1]
df.loc[10]["Max 2"]=IRAMAXS.loc[Day2]
df.loc[10]["Max 3"]=IRAMAXS.loc[Day3]
df.loc[10]["Max 4"]=IRAMAXS.loc[Day4]
df.loc[10]["Max 5"]=IRAMAXS.loc[Day5]

df.loc[10]["Min 1"]=IRAMINS.loc[Day1]
df.loc[10]["Min 2"]=IRAMINS.loc[Day2]
df.loc[10]["Min 3"]=IRAMINS.loc[Day3]
df.loc[10]["Min 4"]=IRAMINS.loc[Day4]
df.loc[10]["Min 5"]=IRAMINS.loc[Day5]


# In[19]:


#KYR
#Create list of times
KYRDATE=[]
for x in weather_dict['Bishkek,Kyrgyzstan']['list']:
    KYRDATE.append(x['dt_txt'])
    
#Make it list of just the day
KYRDAY=[]
for x in KYRDATE:
    KYRDAY.append(int(x[8:10]))
#List of min and max temps
KYRMIN=[]
KYRMAX=[]
for hi in range(0, 40):
    KYRMIN.append(weather_dict['Bishkek,Kyrgyzstan']["list"][hi]['main']['temp_min'])
    KYRMAX.append(weather_dict['Bishkek,Kyrgyzstan']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
KYR=[]
KYR=[KYRDAY, KYRMIN, KYRMAX]

#Throw it in a dataframe
KYR=pd.DataFrame(KYR).transpose()
#Name the columns
KYR.columns=["Date", "Min" , "Max"]

#Let's see it
KYR

#Group by date
KYRMINS=KYR.groupby(["Date"])["Min"].min()
KYRMAXS=KYR.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[11]["Max 1"]=KYRMAXS.loc[Day1]
df.loc[11]["Max 2"]=KYRMAXS.loc[Day2]
df.loc[11]["Max 3"]=KYRMAXS.loc[Day3]
df.loc[11]["Max 4"]=KYRMAXS.loc[Day4]
df.loc[11]["Max 5"]=KYRMAXS.loc[Day5]

df.loc[11]["Min 1"]=KYRMINS.loc[Day1]
df.loc[11]["Min 2"]=KYRMINS.loc[Day2]
df.loc[11]["Min 3"]=KYRMINS.loc[Day3]
df.loc[11]["Min 4"]=KYRMINS.loc[Day4]
df.loc[11]["Min 5"]=KYRMINS.loc[Day5]


# In[20]:


#LAT
#Create list of times
LATDATE=[]
for x in weather_dict['Riga,Latvia']['list']:
        LATDATE.append(x['dt_txt'])
    
#Make it list of just the day
LATDAY=[]
for x in LATDATE:
    LATDAY.append(int(x[8:10]))
#List of min and max temps
LATMIN=[]
LATMAX=[]
for hi in range(0, 40):
    LATMIN.append(weather_dict['Riga,Latvia']["list"][hi]['main']['temp_min'])
    LATMAX.append(weather_dict['Riga,Latvia']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
LAT=[]
LAT=[LATDAY, LATMIN, LATMAX]

#Throw it in a dataframe
LAT=pd.DataFrame(LAT).transpose()
#Name the columns
LAT.columns=["Date", "Min" , "Max"]

#Let's see it
LAT

#Group by date
LATMINS=LAT.groupby(["Date"])["Min"].min()
LATMAXS=LAT.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[12]["Max 1"]=LATMAXS.loc[Day1]
df.loc[12]["Max 2"]=LATMAXS.loc[Day2]
df.loc[12]["Max 3"]=LATMAXS.loc[Day3]
df.loc[12]["Max 4"]=LATMAXS.loc[Day4]
df.loc[12]["Max 5"]=LATMAXS.loc[Day5]

df.loc[12]["Min 1"]=LATMINS.loc[Day1]
df.loc[12]["Min 2"]=LATMINS.loc[Day2]
df.loc[12]["Min 3"]=LATMINS.loc[Day3]
df.loc[12]["Min 4"]=LATMINS.loc[Day4]
df.loc[12]["Min 5"]=LATMINS.loc[Day5]


# In[21]:


#PAK
#Create list of times
PAKDATE=[]
for x in weather_dict['Quetta,Pakistan']['list']:
    PAKDATE.append(x['dt_txt'])
    
#Make it list of just the day
PAKDAY=[]
for x in PAKDATE:
    PAKDAY.append(int(x[8:10]))
#List of min and max temps
PAKMIN=[]
PAKMAX=[]
for hi in range(0, 40):
    PAKMIN.append(weather_dict['Quetta,Pakistan']["list"][hi]['main']['temp_min'])
    PAKMAX.append(weather_dict['Quetta,Pakistan']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
PAK=[]
PAK=[PAKDAY, PAKMIN, PAKMAX]

#Throw it in a dataframe
PAK=pd.DataFrame(PAK).transpose()
#Name the columns
PAK.columns=["Date", "Min" , "Max"]

#Let's see it
PAK

#Group by date
PAKMINS=PAK.groupby(["Date"])["Min"].min()
PAKMAXS=PAK.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[13]["Max 1"]=PAKMAXS.loc[Day1]
df.loc[13]["Max 2"]=PAKMAXS.loc[Day2]
df.loc[13]["Max 3"]=PAKMAXS.loc[Day3]
df.loc[13]["Max 4"]=PAKMAXS.loc[Day4]
df.loc[13]["Max 5"]=PAKMAXS.loc[Day5]

df.loc[13]["Min 1"]=PAKMINS.loc[Day1]
df.loc[13]["Min 2"]=PAKMINS.loc[Day2]
df.loc[13]["Min 3"]=PAKMINS.loc[Day3]
df.loc[13]["Min 4"]=PAKMINS.loc[Day4]
df.loc[13]["Min 5"]=PAKMINS.loc[Day5]


# In[22]:


#POL
#Create list of times
POLDATE=[]
for x in weather_dict['Warsaw,Poland']['list']:
        POLDATE.append(x['dt_txt'])
    
#Make it list of just the day
POLDAY=[]
for x in POLDATE:
    POLDAY.append(int(x[8:10]))
#List of min and max temps
POLMIN=[]
POLMAX=[]
for hi in range(0, 40):
    POLMIN.append(weather_dict['Warsaw,Poland']["list"][hi]['main']['temp_min'])
    POLMAX.append(weather_dict['Warsaw,Poland']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
POL=[]
POL=[POLDAY, POLMIN, POLMAX]

#Throw it in a dataframe
POL=pd.DataFrame(POL).transpose()
#Name the columns
POL.columns=["Date", "Min" , "Max"]

#Let's see it
POL

#Group by date
POLMINS=POL.groupby(["Date"])["Min"].min()
POLMAXS=POL.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[14]["Max 1"]=POLMAXS.loc[Day1]
df.loc[14]["Max 2"]=POLMAXS.loc[Day2]
df.loc[14]["Max 3"]=POLMAXS.loc[Day3]
df.loc[14]["Max 4"]=POLMAXS.loc[Day4]
df.loc[14]["Max 5"]=POLMAXS.loc[Day5]

df.loc[14]["Min 1"]=POLMINS.loc[Day1]
df.loc[14]["Min 2"]=POLMINS.loc[Day2]
df.loc[14]["Min 3"]=POLMINS.loc[Day3]
df.loc[14]["Min 4"]=POLMINS.loc[Day4]
df.loc[14]["Min 5"]=POLMINS.loc[Day5]


# In[23]:


#SAU
#Create list of times
SAUDATE=[]
for x in weather_dict['Dhahran,SaudiaArabia']['list']:
    SAUDATE.append(x['dt_txt'])
    
#Make it list of just the day
SAUDAY=[]
for x in SAUDATE:
    SAUDAY.append(int(x[8:10]))
#List of min and max temps
SAUMIN=[]
SAUMAX=[]
for hi in range(0, 40):
    SAUMIN.append(weather_dict['Dhahran,SaudiaArabia']["list"][hi]['main']['temp_min'])
    SAUMAX.append(weather_dict['Dhahran,SaudiaArabia']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
SAU=[]
SAU=[SAUDAY, SAUMIN, SAUMAX]

#Throw it in a dataframe
SAU=pd.DataFrame(SAU).transpose()
#Name the columns
SAU.columns=["Date", "Min" , "Max"]

#Let's see it
SAU

#Group by date
SAUMINS=SAU.groupby(["Date"])["Min"].min()
SAUMAXS=SAU.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[15]["Max 1"]=SAUMAXS.loc[Day1]
df.loc[15]["Max 2"]=SAUMAXS.loc[Day2]
df.loc[15]["Max 3"]=SAUMAXS.loc[Day3]
df.loc[15]["Max 4"]=SAUMAXS.loc[Day4]
df.loc[15]["Max 5"]=SAUMAXS.loc[Day5]

df.loc[15]["Min 1"]=SAUMINS.loc[Day1]
df.loc[15]["Min 2"]=SAUMINS.loc[Day2]
df.loc[15]["Min 3"]=SAUMINS.loc[Day3]
df.loc[15]["Min 4"]=SAUMINS.loc[Day4]
df.loc[15]["Min 5"]=SAUMINS.loc[Day5]


# In[24]:


#SPA
#Create list of times
SPADATE=[]
for x in weather_dict['Madrid,Spain']['list']:
    SPADATE.append(x['dt_txt'])
    
#Make it list of just the day
SPADAY=[]
for x in SPADATE:
    SPADAY.append(int(x[8:10]))
#List of min and max temps
SPAMIN=[]
SPAMAX=[]
for hi in range(0, 40):
    SPAMIN.append(weather_dict['Madrid,Spain']["list"][hi]['main']['temp_min'])
    SPAMAX.append(weather_dict['Madrid,Spain']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
SPA=[]
SPA=[SPADAY, SPAMIN, SPAMAX]

#Throw it in a dataframe
SPA=pd.DataFrame(SPA).transpose()
#Name the columns
SPA.columns=["Date", "Min" , "Max"]

#Let's see it
SPA

#Group by date
SPAMINS=SPA.groupby(["Date"])["Min"].min()
SPAMAXS=SPA.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[16]["Max 1"]=SPAMAXS.loc[Day1]
df.loc[16]["Max 2"]=SPAMAXS.loc[Day2]
df.loc[16]["Max 3"]=SPAMAXS.loc[Day3]
df.loc[16]["Max 4"]=SPAMAXS.loc[Day4]
df.loc[16]["Max 5"]=SPAMAXS.loc[Day5]

df.loc[16]["Min 1"]=SPAMINS.loc[Day1]
df.loc[16]["Min 2"]=SPAMINS.loc[Day2]
df.loc[16]["Min 3"]=SPAMINS.loc[Day3]
df.loc[16]["Min 4"]=SPAMINS.loc[Day4]
df.loc[16]["Min 5"]=SPAMINS.loc[Day5]


# In[25]:


#ENG
#Create list of times
ENGDATE=[]
for x in weather_dict['Oldham,England']['list']:
    ENGDATE.append(x['dt_txt'])
    
#Make it list of just the day
ENGDAY=[]
for x in ENGDATE:
    ENGDAY.append(int(x[8:10]))
#List of min and max temps
ENGMIN=[]
ENGMAX=[]
for hi in range(0, 40):
    ENGMIN.append(weather_dict['Oldham,England']["list"][hi]['main']['temp_min'])
    ENGMAX.append(weather_dict['Oldham,England']["list"][hi]['main']['temp_max'])
#Write everything to a mega list
ENG=[]
ENG=[ENGDAY, ENGMIN, ENGMAX]

#Throw it in a dataframe
ENG=pd.DataFrame(ENG).transpose()
#Name the columns
ENG.columns=["Date", "Min" , "Max"]

#Let's see it
ENG

#Group by date
ENGMINS=ENG.groupby(["Date"])["Min"].min()
ENGMAXS=ENG.groupby(["Date"])["Max"].max()

#Put it in the dataframe
df.loc[17]["Max 1"]=ENGMAXS.loc[Day1]
df.loc[17]["Max 2"]=ENGMAXS.loc[Day2]
df.loc[17]["Max 3"]=ENGMAXS.loc[Day3]
df.loc[17]["Max 4"]=ENGMAXS.loc[Day4]
df.loc[17]["Max 5"]=ENGMAXS.loc[Day5]

df.loc[17]["Min 1"]=ENGMINS.loc[Day1]
df.loc[17]["Min 2"]=ENGMINS.loc[Day2]
df.loc[17]["Min 3"]=ENGMINS.loc[Day3]
df.loc[17]["Min 4"]=ENGMINS.loc[Day4]
df.loc[17]["Min 5"]=ENGMINS.loc[Day5]


# In[26]:


#5 Day Max Average Lists
y1 = [df.loc[1]["Max 1"], df.loc[1]["Max 2"] , df.loc[1]["Max 3"] , df.loc[1]["Max 4"] , df.loc[1]["Max 5"]]
y2 = [df.loc[2]["Max 1"], df.loc[2]["Max 2"] , df.loc[2]["Max 3"] , df.loc[2]["Max 4"] , df.loc[2]["Max 5"]]
y3 = [df.loc[3]["Max 1"], df.loc[3]["Max 2"] , df.loc[3]["Max 3"] , df.loc[3]["Max 4"] , df.loc[3]["Max 5"]]
y4 = [df.loc[4]["Max 1"], df.loc[4]["Max 2"] , df.loc[4]["Max 3"] , df.loc[4]["Max 4"] , df.loc[4]["Max 5"]]
y5 = [df.loc[5]["Max 1"], df.loc[5]["Max 2"] , df.loc[5]["Max 3"] , df.loc[5]["Max 4"] , df.loc[5]["Max 5"]]
y6 = [df.loc[6]["Max 1"], df.loc[6]["Max 2"] , df.loc[6]["Max 3"] , df.loc[6]["Max 4"] , df.loc[6]["Max 5"]]
y7 = [df.loc[7]["Max 1"], df.loc[7]["Max 2"] , df.loc[7]["Max 3"] , df.loc[7]["Max 4"] , df.loc[7]["Max 5"]]
y8 = [df.loc[8]["Max 1"], df.loc[8]["Max 2"] , df.loc[8]["Max 3"] , df.loc[8]["Max 4"] , df.loc[8]["Max 5"]]
y9 = [df.loc[9]["Max 1"], df.loc[9]["Max 2"] , df.loc[9]["Max 3"] , df.loc[9]["Max 4"] , df.loc[9]["Max 5"]]
y10 = [df.loc[10]["Max 1"], df.loc[10]["Max 2"] , df.loc[10]["Max 3"] , df.loc[10]["Max 4"] , df.loc[10]["Max 5"]]
y11 = [df.loc[11]["Max 1"], df.loc[11]["Max 2"] , df.loc[11]["Max 3"] , df.loc[11]["Max 4"] , df.loc[11]["Max 5"]]
y12 = [df.loc[12]["Max 1"], df.loc[12]["Max 2"] , df.loc[12]["Max 3"] , df.loc[12]["Max 4"] , df.loc[12]["Max 5"]]
y13 = [df.loc[13]["Max 1"], df.loc[13]["Max 2"] , df.loc[13]["Max 3"] , df.loc[13]["Max 4"] , df.loc[13]["Max 5"]]
y14 = [df.loc[14]["Max 1"], df.loc[14]["Max 2"] , df.loc[14]["Max 3"] , df.loc[14]["Max 4"] , df.loc[14]["Max 5"]]
y15 = [df.loc[15]["Max 1"], df.loc[15]["Max 2"] , df.loc[15]["Max 3"] , df.loc[15]["Max 4"] , df.loc[15]["Max 5"]]
y16 = [df.loc[16]["Max 1"], df.loc[16]["Max 2"] , df.loc[16]["Max 3"] , df.loc[16]["Max 4"] , df.loc[16]["Max 5"]]
y17 = [df.loc[17]["Max 1"], df.loc[17]["Max 2"] , df.loc[17]["Max 3"] , df.loc[17]["Max 4"] , df.loc[17]["Max 5"]]

#5 Day Min Average Lists
x1 = [df.loc[1]["Min 1"], df.loc[1]["Min 2"] , df.loc[1]["Min 3"] , df.loc[1]["Min 4"] , df.loc[1]["Min 5"]]
x2 = [df.loc[2]["Min 1"], df.loc[2]["Min 2"] , df.loc[2]["Min 3"] , df.loc[2]["Min 4"] , df.loc[2]["Min 5"]]
x3 = [df.loc[3]["Min 1"], df.loc[3]["Min 2"] , df.loc[3]["Min 3"] , df.loc[3]["Min 4"] , df.loc[3]["Min 5"]]
x4 = [df.loc[4]["Min 1"], df.loc[4]["Min 2"] , df.loc[4]["Min 3"] , df.loc[4]["Min 4"] , df.loc[4]["Min 5"]]
x5 = [df.loc[5]["Min 1"], df.loc[5]["Min 2"] , df.loc[5]["Min 3"] , df.loc[5]["Min 4"] , df.loc[5]["Min 5"]]
x6 = [df.loc[6]["Min 1"], df.loc[6]["Min 2"] , df.loc[6]["Min 3"] , df.loc[6]["Min 4"] , df.loc[6]["Min 5"]]
x7 = [df.loc[7]["Min 1"], df.loc[7]["Min 2"] , df.loc[7]["Min 3"] , df.loc[7]["Min 4"] , df.loc[7]["Min 5"]]
x8 = [df.loc[8]["Min 1"], df.loc[8]["Min 2"] , df.loc[8]["Min 3"] , df.loc[8]["Min 4"] , df.loc[8]["Min 5"]]
x9 = [df.loc[9]["Min 1"], df.loc[9]["Min 2"] , df.loc[9]["Min 3"] , df.loc[9]["Min 4"] , df.loc[9]["Min 5"]]
x10 = [df.loc[10]["Min 1"], df.loc[10]["Min 2"] , df.loc[10]["Min 3"] , df.loc[10]["Min 4"] , df.loc[10]["Min 5"]]
x11 = [df.loc[11]["Min 1"], df.loc[11]["Min 2"] , df.loc[11]["Min 3"] , df.loc[11]["Min 4"] , df.loc[11]["Min 5"]]
x12 = [df.loc[12]["Min 1"], df.loc[12]["Min 2"] , df.loc[12]["Min 3"] , df.loc[12]["Min 4"] , df.loc[12]["Min 5"]]
x13 = [df.loc[13]["Min 1"], df.loc[13]["Min 2"] , df.loc[13]["Min 3"] , df.loc[13]["Min 4"] , df.loc[13]["Min 5"]]
x14 = [df.loc[14]["Min 1"], df.loc[14]["Min 2"] , df.loc[14]["Min 3"] , df.loc[14]["Min 4"] , df.loc[14]["Min 5"]]
x15 = [df.loc[15]["Min 1"], df.loc[15]["Min 2"] , df.loc[15]["Min 3"] , df.loc[15]["Min 4"] , df.loc[15]["Min 5"]]
x16 = [df.loc[16]["Min 1"], df.loc[16]["Min 2"] , df.loc[16]["Min 3"] , df.loc[16]["Min 4"] , df.loc[16]["Min 5"]]
x17 = [df.loc[17]["Min 1"], df.loc[17]["Min 2"] , df.loc[17]["Min 3"] , df.loc[17]["Min 4"] , df.loc[17]["Min 5"]]


# In[27]:


#5 Day Max Average Calculation
df.loc[1]["Max Avg"] = statistics.mean(y1)
df.loc[2]["Max Avg"] = statistics.mean(y2)
df.loc[3]["Max Avg"] = statistics.mean(y3)
df.loc[4]["Max Avg"] = statistics.mean(y4)
df.loc[5]["Max Avg"] = statistics.mean(y5)
df.loc[6]["Max Avg"] = statistics.mean(y6)
df.loc[7]["Max Avg"] = statistics.mean(y7)
df.loc[8]["Max Avg"] = statistics.mean(y8)
df.loc[9]["Max Avg"] = statistics.mean(y9)
df.loc[10]["Max Avg"] = statistics.mean(y10)
df.loc[11]["Max Avg"] = statistics.mean(y11)
df.loc[12]["Max Avg"] = statistics.mean(y12)
df.loc[13]["Max Avg"] = statistics.mean(y13)
df.loc[14]["Max Avg"] = statistics.mean(y14)
df.loc[15]["Max Avg"] = statistics.mean(y15)
df.loc[16]["Max Avg"] = statistics.mean(y16)
df.loc[17]["Max Avg"] = statistics.mean(y17)

#5 Day Min Average Calculation
df.loc[1]["Min Avg"] = statistics.mean(x1)
df.loc[2]["Min Avg"] = statistics.mean(x2)
df.loc[3]["Min Avg"] = statistics.mean(x3)
df.loc[4]["Min Avg"] = statistics.mean(x4)
df.loc[5]["Min Avg"] = statistics.mean(x5)
df.loc[6]["Min Avg"] = statistics.mean(x6)
df.loc[7]["Min Avg"] = statistics.mean(x7)
df.loc[8]["Min Avg"] = statistics.mean(x8)
df.loc[9]["Min Avg"] = statistics.mean(x9)
df.loc[10]["Min Avg"] = statistics.mean(x10)
df.loc[11]["Min Avg"] = statistics.mean(x11)
df.loc[12]["Min Avg"] = statistics.mean(x12)
df.loc[13]["Min Avg"] = statistics.mean(x13)
df.loc[14]["Min Avg"] = statistics.mean(x14)
df.loc[15]["Min Avg"] = statistics.mean(x15)
df.loc[16]["Min Avg"] = statistics.mean(x16)
df.loc[17]["Min Avg"] = statistics.mean(x17)


# In[28]:


df['Min Avg'] = df['Min Avg'].astype(float)
df['Min Avg'] = np.round(df['Min Avg'], decimals = 2)

df['Max Avg'] = df['Max Avg'].astype(float)
df['Max Avg'] = np.round(df['Max Avg'], decimals = 2)


# In[29]:


df


# In[30]:


df.to_csv(r'C:\Users\sehoc\OneDrive\Desktop\ocampoapi.csv')

