#!/bin/bash
# =========================================
# Teste de Conectividade
# Autor: Aurelio Martins
# Data: 2025-09-02
# =========================================

echo "🔄 Testando conectividade com $1..."
ping -c 4 "$1"
