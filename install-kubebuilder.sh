# download kubebuilder and install locally.
curl -L -o kubebuilder https://go.kubebuilder.io/dl/latest/linux/amd64
chmod +x kubebuilder && mv kubebuilder $HOME/bin/

cat << EOM
Enable shell completion by adding

complete -C kubebuilder completion <bash|zsh>
EOM

