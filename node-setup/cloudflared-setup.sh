echo "⏳⏳ Installing cloudflared"

sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt-get update && sudo apt-get install cloudflared
echo "✅ Cloudflared installed"

echo "⏳⏳ Setting up cloudflared secrets"
ln -fs ~/winterfell/winterfell-secrets/cloudflared/ ~/.cloudflared
echo "✅ Cloudflared secrets setup"

echo "⏳⏳ Configuring cloudflared service"
sudo cloudflared --config /home/ghost/winterfell/winterfell-secrets/cloudflared/config.yml service install
systemctl start cloudflared
echo "✅ Cloudflared service configured"

systemctl status cloudflared
