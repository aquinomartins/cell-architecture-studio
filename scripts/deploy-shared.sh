#!/usr/bin/env bash
set -euo pipefail

PUBLIC_DIR="${PUBLIC_DIR:-../public_html}"
INSTALL_CMD="${INSTALL_CMD:-ci}"

if [[ "$INSTALL_CMD" == "install" ]]; then
  echo "[deploy-shared] Instalando dependências com npm install..."
  npm install
else
  echo "[deploy-shared] Instalando dependências com npm ci..."
  npm ci
fi

echo "[deploy-shared] Gerando build de produção..."
npm run build:prod

if [[ ! -d dist ]]; then
  echo "[deploy-shared] ERRO: pasta dist não foi gerada." >&2
  exit 1
fi

mkdir -p "$PUBLIC_DIR"

echo "[deploy-shared] Publicando arquivos em: $PUBLIC_DIR"

echo "[deploy-shared] Limpando apenas arquivos de build conhecidos no destino..."
rm -rf "$PUBLIC_DIR/assets"
find "$PUBLIC_DIR" -maxdepth 1 -type f \( -name '*.html' -o -name '*.js' -o -name '*.mjs' -o -name '*.css' -o -name '*.map' -o -name '*.txt' \) -delete

echo "[deploy-shared] Copiando conteúdo de dist/ para $PUBLIC_DIR ..."
cp -a dist/. "$PUBLIC_DIR/"

echo "[deploy-shared] Deploy concluído com sucesso."
