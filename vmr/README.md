# The Virtual Microbial Resource

# This project does the following:

1. Constructs a dictionary of allowable fields and terms based on the Reference Field and Term guide ontology (https://github.com/cidgoh/GRDI_AMR_One_Health)
2. Takes an input sheet of user data from the GRDI_Harmonization-Template
3. Identifies any fields or terms that are not part of the ontology
4. Validates user data for duplication or other input errors
5. Inserts the data that passes verification into the PostgreSQL VMR DB
