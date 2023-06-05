import rdflib
from rdflib import Literal, URIRef
import sys
import re
def owl_parsing():
    g = rdflib.Graph()
    g.parse("foodon.owl")

    query = """
        PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        PREFIX owl: <http://www.w3.org/2002/07/owl#>
        SELECT ?class ?label
        WHERE {
            ?class a owl:Class .
            ?class rdfs:label ?label .
            
        }
    """

    results = g.query(query)
    foodon_dict= {}
    for row in results:
        class_uri = row["class"]
        
        label = row["label"]
        if "FOODON" in class_uri:
            match = re.search("FOODON_\d+", class_uri)
            #print(match.group(),label)
            label = Literal(label)
            label = str(label)
            label = label.replace("'","")
            foodon_dict[match.group()] = label
        elif "ENVO" in class_uri:
            match = re.search("ENVO_\d+", class_uri)
            label = Literal(label)
            label = str(label)
            label = label.replace("'","")
            foodon_dict[match.group()] = label
            #print(match.group(),label)
        elif "AGRO" in class_uri:
            match = re.search("AGRO_\d+", class_uri)
            label = Literal(label)
            label = str(label)
            label = label.replace("'","")
            foodon_dict[match.group()] = label
            #print(class_uri,label)
        elif "UBERON" in class_uri:
            match = re.search("UBERON_\d+", class_uri)
            label = Literal(label)
            label = str(label)
            label = label.replace("'","")
            foodon_dict[match.group()] = label
            #print(match.group(),Literal(label))
    return(foodon_dict)