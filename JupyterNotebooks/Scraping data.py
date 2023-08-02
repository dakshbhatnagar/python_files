import pandas as pd
from bs4 import BeautifulSoup
import requests

class webscraper():
    
    def __init__(self):
        data =  None

    def scrape_data(self):

        '''
        This function will scrape data from cspm.gov.in and returns it in the form of a pandas dataframe
        '''
        from bs4 import BeautifulSoup
        import requests

        url = 'http://www.cspm.gov.in/ocmstemp/project_ind.bhr_proc_agency_wise'
        response = requests.get(url)

        #Creating a beautiful soup object
        soup = BeautifulSoup(response.text,'html.parser')

        #Extracting all the text from the website using soup object and find_all method and python's list comprehension
        my_list = [i.text for i in soup.find_all('td')]

        #Creating column headers
        column_headers = [i.text for i in soup.find_all('td')][4:11]

        #fetching the columns one by one from the text extracted earlier
        agency_names = []
        for i in range(12, len(my_list)-8, 8):
            agency_names.append(my_list[i])

        sector_names = []
        for i in range(13, len(my_list)-8, 8):
            sector_names.append(my_list[i]) 

        project_names = []
        for i in range(14, len(my_list), 8):
            project_names.append(my_list[i])
        
        #Removing spaces from the project names
        project_names = [i.strip() for i in project_names]

        approval_date = []
        for i in range(15, len(my_list), 8):
            approval_date.append((my_list[i]))

        original_cost = []
        for i in range(16, len(my_list), 8):
            original_cost.append(my_list[i])

        anticipated_cost = []
        for i in range(17, len(my_list), 8):
            anticipated_cost.append(my_list[i])

        Expenditure = []
        for i in range(18, len(my_list), 8):
            Expenditure.append(my_list[i])
        
        #Converting into appropriate data types 
        import pandas as pd
        approval_date = pd.to_datetime(approval_date)
        original_cost = [float(i) for i in original_cost]
        anticipated_cost = [float(i) for i in anticipated_cost]
        Expenditure = [float(i) for i in Expenditure]
        
        #Combing the columns and making a list out of it
        self.data = [agency_names, sector_names, project_names, approval_date, original_cost, anticipated_cost, Expenditure ]

        #Creating a data frame
        df = pd.DataFrame(self.data).T
        df.columns = column_headers

        #Dropping any null values
        df.dropna(inplace=True)

        #returning the dataframe
        return df

#Initializing the class
scraper = webscraper()

#Scraping the data by calling the function of the class
data = scraper.scrape_data()
