from pymisp import ExpandedPyMISP

misp_url = 'https://localhost:8082'
misp_key = 'rhkEyIJyiUeRY88SGdf4nY1RFeFQQD0SlsvtPLKv'

misp = ExpandedPyMISP(misp_url, misp_key, False)
events = misp.search(controller='events')
print(str(events))
