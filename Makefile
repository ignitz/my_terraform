all:
ifeq (,$(wildcard ./modules/key_pair/keys/id_rsa))
		@./generate.sh
endif

	@terraform init && \
	terraform apply -auto-approve && \
	terraform output -json > infra.json
	@say -v Luciana Ou seu animal, o deploy acabou de subir, vem ver

ssh:
	@ssh -i modules/key_pair/keys/id_rsa ubuntu@$(shell cat infra.json | jq .public_address.value)

clean:
	@terraform destroy -auto-approve && rm infra.json
	@say -v Luciana Acabei de deletar tudo, espero que você não se arrependa de nada