**Actualizar Arch Linux** (opcional pero recomendable): Abre una terminal y ejecuta el siguiente comando para asegurarte de que tu sistema esté actualizado:
```bash
sudo pacman -Syu
```

**Instalar los paquetes necesarios**: Necesitarás instalar algunos paquetes antes de poder instalar las Guest Additions:
```bash
sudo pacman -S virtualbox-guest-utils linux-headers dkms
```

**Habilitar los servicios de VirtualBox Guest Additions**: Una vez que los paquetes están instalados, debes habilitar y iniciar los servicios necesarios para las Guest Additions:
```bash
sudo systemctl enable vboxservice 
sudo systemctl start vboxservice
```

**Reiniciar la máquina virtual**: Reinicia tu máquina virtual de Arch Linux para que los cambios surtan efecto
```bash
sudo reboot
```