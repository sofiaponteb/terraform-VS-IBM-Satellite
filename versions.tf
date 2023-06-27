terraform {
required_version = ">=1.0.0, <2.0"
required_providers {
    ibm = {
    source = "IBM-Cloud/ibm" # si no incluyo version para el provider toma la ultima 
    }
 }
}