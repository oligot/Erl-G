class BANK_ACCOUNT
feature
	owner: PERSON
	balance: INTEGER
	make (p: PERSON; init_bal: INTEGER) is do end
	make_with_default_balance (p: PERSON) is do end
	withdraw (sum: INTEGER) is do end
	set_owner (p: PERSON) is do end
	set_balance (b: INTEGER) is do end
end
