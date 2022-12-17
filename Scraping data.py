from bs4 import BeautifulSoup
import requests


url = 'http://www.cspm.gov.in/ocmstemp/project_ind.bhr_proc_agency_wise'
response = requests.get(url)
soup = BeautifulSoup(response.text,'html.parser')

my_list = [i.text for i in soup.find_all('td')]
column_headers = [i.text for i in soup.find_all('td')][4:11]

def scrape_data():
    agency_names = []
    for i in range(12, len(my_list)-8, 8):
        agency_names.append(my_list[i])

    sector_names = []
    for i in range(13, len(my_list)-8, 8):
        sector_names.append(my_list[i]) 

    project_names = []
    for i in range(14, len(my_list), 8):
        project_names.append(my_list[i])

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

    data = [agency_names,  sector_names, project_names, approval_date, original_cost, anticipated_cost, Expenditure ]
    return data

class webscraper():
    
    def __init__(self):
        data =  None

    def scrape_data(self):

        '''
        This function will scrape data from cspm.gov.in and returns it in the form of a list
        '''
        from bs4 import BeautifulSoup
        import requests

        url = 'http://www.cspm.gov.in/ocmstemp/project_ind.bhr_proc_agency_wise'
        response = requests.get(url)
        soup = BeautifulSoup(response.text,'html.parser')

        my_list = [i.text for i in soup.find_all('td')]
        column_headers = [i.text for i in soup.find_all('td')][4:11]
        
        agency_names = []
        for i in range(12, len(my_list)-8, 8):
            agency_names.append(my_list[i])

        sector_names = []
        for i in range(13, len(my_list)-8, 8):
            sector_names.append(my_list[i]) 

        project_names = []
        for i in range(14, len(my_list), 8):
            project_names.append(my_list[i])

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

        self.data = [agency_names, sector_names, project_names, approval_date, original_cost, anticipated_cost, Expenditure ]

        original_cost = [float(i) for i in original_cost]
        anticipated_cost = [float(i) for i in anticipated_cost]
        Expenditure = [float(i) for i in Expenditure]
        
        import pandas as pd
        
        approval_date = pd.to_datetime(approval_date)

        return self.data

