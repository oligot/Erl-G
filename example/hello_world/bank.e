class BANK
feature
	name: STRING
	accounts: LINKED_LIST [BANK_ACCOUNT]
	make (s: STRING) is do end
	add_account (a: BANK_ACCOUNT) is do end
end
