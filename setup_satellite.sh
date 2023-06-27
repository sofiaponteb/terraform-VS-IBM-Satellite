#!/bin/bash

# Refrescar máquinas de Red Hat
subscription-manager refresh

# Habilitar el paquete de repositorios en la máquina
subscription-manager repos --enable rhel-8-for-x86_64-appstream-rpms
subscription-manager repos --enable rhel-8-for-x86_64-baseos-rpms
