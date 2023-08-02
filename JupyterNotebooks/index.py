#This app takes data from a google sheet using Google Sheets and Google Drive API and then creates a Streamlit app to show selections and Joinings in a month and quarter
import pandas as pd
import gspread
import numpy as np
from oauth2client.service_account import ServiceAccountCredentials
from googleapiclient import discovery
import streamlit as st
from pandasql import sqldf

scope = ['https://spreadsheets.google.com/feeds','https://www.googleapis.com/auth/drive']
# add credentials to the account
creds = ServiceAccountCredentials.from_json_keyfile_name('keys.json', scope)
service = discovery.build('sheets', 'v4', credentials=creds)
# The ID of the spreadsheet to retrieve data from.
spreadsheet_id = '1Hg93I7Kxj8S9RNRznJS3m6uubtq7Nx7Pvj-oS_1YEKo' 
# The A1 notation of the values to retrieve.
range_ = 'A1:M'  
value_render_option = 'FORMATTED_VALUE'  
date_time_render_option = 'FORMATTED_STRING'  
request = service.spreadsheets().values().get(spreadsheetId=spreadsheet_id, range=range_, 
                                              valueRenderOption=value_render_option, 
                                              dateTimeRenderOption=date_time_render_option)
response = request.execute()
#fetching all the values from the request returned by the API
data = response['values']
#creating the dataframe
df = pd.DataFrame(data)
df.columns = df.iloc[0]
df.drop([0], inplace =True)
df.dropna(axis='rows', inplace=True)
#Creating tabs of the app
tab1, tab2 = st.tabs(["Month Selections", "Qtr Selections"])

# # #Month Tab Details
if tab1:
    month = tab1.selectbox('Pick a month', ('Jan','Feb', 'Mar', 'Apr', 'May', 'Jun','Jul','Aug','Sep','Oct', 'Nov', 'Dec'))
    monthly_df = df[(df['Selection Month'] == month)]
    joined_df = df[(df['Joining Month'] == month) & (df[' Joining Status'] == 'Joined')]
    tab1.header(f'Selections in {month} : {len(monthly_df)} , Joinings in {month} : {len(joined_df)}')
    tab1.subheader('Selections Data')
    # new_df = pd.DataFrame()
    # q = "SELECT Team, Recruiter, COUNT(Recruiter) as 'Joinings', AVG(Recruiter_Salary) as 'Rec Salary', SUM(Billable_CTC) as 'Billable CTC', SUM(Billable_CTC)/AVG(Recruiter_Salary) as 'Tgt Achd' FROM monthly_df group by Recruiter order by COUNT(Recruiter) desc"
    # new_df = sqldf(q, globals())
    # tab1.subheader(f"{len(monthly_df)} Joined in {month}")
    # filtered_df = new_df[['Recruiter','Joinings']].sort_values(by='Joinings',ascending=False)
    # filtered_df =  filtered_df.set_index('Recruiter')
    # tab1.bar_chart(filtered_df)

    tab1.dataframe(monthly_df)
    tab1.subheader('Joinings Data')
    tab1.dataframe(joined_df)
    
if tab2:
    qtr = tab2.selectbox('Pick a quarter', ('Q1','Q2', 'Q3', 'Q4'))
    qtr_df = df[df['Qtr'] ==qtr]
    q = "SELECT Recruiter, COUNT(Recruiter) as 'Selections' FROM qtr_df group by Recruiter order by COUNT(Recruiter) desc"
    new_df = sqldf(q, globals())
    tab2.subheader(f"{qtr} Selections Count : {sum(new_df['Selections'])}")
    tab2.bar_chart(data=new_df, x='Recruiter', y='Selections')
    tab2.subheader(f'{qtr} Selections Table')
    tab2.dataframe(qtr_df)
    
    joined_df_qtr = qtr_df[qtr_df[' Joining Status']=='Joined']
    q = "SELECT Recruiter, COUNT(Recruiter) as 'Joinings' FROM qtr_df group by Recruiter order by COUNT(Recruiter) desc"
    new_df = sqldf(q, globals())
    tab2.subheader(f"{qtr} Joinings Count : {len(joined_df_qtr)}")
    tab2.bar_chart(data=new_df, x='Recruiter', y='Joinings')
    tab2.subheader(f'{qtr} Joinings Table')
    tab2.dataframe(joined_df_qtr)
    

with st.sidebar:
    logo ='https://qssglobal.com/wp-content/uploads/2023/01/QSS-Global-Logo.png'
    st.image(logo, width=200)
    add_radio = st.markdown("<h1 style='text-align: center; color: black; font-size: 55px;'>Selections and Joinings</h1>", 
                unsafe_allow_html=True)
