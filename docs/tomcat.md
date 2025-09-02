Instalação do Apache Tomcat 9 em /mnt/dados/tomcat9 – Rocky Linux 9.6

🔧 1. Instalar dependências e preparar ambiente

bash
CopiarEditar
# Atualizar pacotes
sudo dnf update -y
# Instalar Java (Tomcat 9 requer Java 8+)
sudo dnf install java-11-openjdk-devel -y
# Criar ponto de montagem do disco (se ainda não existir)
sudo mkdir -p /mnt/dados
sudo mount /dev/sdb1 /mnt/dados   # Se não estiver montado automaticamente
# Criar diretório do Tomcat
sudo mkdir -p /mnt/dados/tomcat9

👤 2. Criar usuário e grupo tomcat

bash
CopiarEditar
# Criar o usuário do Tomcat, se ainda não existir
getent passwd tomcat || sudo useradd -r -m -U -d /mnt/dados/tomcat9 -s /bin/false tomcat

🌐 3. Baixar e instalar o Tomcat 9

bash
CopiarEditar
# Baixar Tomcat
cd /tmp
curl -O https://downloads.apache.org/tomcat/tomcat-9/v9.0.87/bin/apache-tomcat-9.0.87.tar.gz
# Extrair diretamente para o diretório de destino
sudo tar -xzvf apache-tomcat-9.0.87.tar.gz -C /mnt/dados/tomcat9 --strip-components=1
# Ajustar permissões
sudo chown -R tomcat: /mnt/dados/tomcat9
sudo chmod +x /mnt/dados/tomcat9/bin/*.sh

🧠 4. Configurar SELinux (se ativo)

bash
CopiarEditar
# Verificar se SELinux está ativo
getenforce
# Se estiver "Enforcing", rotular corretamente o diretório do Tomcat
sudo dnf install -y policycoreutils-python-utils
sudo semanage fcontext -a -t tomcat_var_lib_t "/mnt/dados/tomcat9(/.*)?"
sudo restorecon -Rv /mnt/dados/tomcat9

⚙️ 5. Criar o serviço SystemD

bash
CopiarEditar
sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOF
[Unit]
Description=Apache Tomcat 9
After=network.target
[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk"
Environment="CATALINA_PID=/mnt/dados/tomcat9/temp/tomcat.pid"
Environment="CATALINA_HOME=/mnt/dados/tomcat9"
Environment="CATALINA_BASE=/mnt/dados/tomcat9"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.security.egd=file:/dev/./urandom"
ExecStart=/mnt/dados/tomcat9/bin/startup.sh
ExecStop=/mnt/dados/tomcat9/bin/shutdown.sh
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

🔄 6. Ativar e iniciar o Tomcat

bash
CopiarEditar
# Recarregar systemd
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
# Habilitar e iniciar o Tomcat
sudo systemctl enable --now tomcat
# Verificar status
sudo systemctl status tomcat

🔓 7. Liberar a porta 8080 no firewalld (se ativo)

bash
CopiarEditar
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload

🌍 8. Acessar via navegador

text
CopiarEditar
http://<IP_DO_SERVIDOR>:8080

✅ Instalação finalizada
🗂️ Diretório de instalação:

bash
CopiarEditar
/mnt/dados/tomcat9
👤 Usuário:

scss
CopiarEditar
tomcat (sem shell, sem login)
🔒 Segurança:
	• Usuário restrito
	• SELinux compatível
	• Firewall controlado
