db["transactions"].countDocuments({
	"type": 3,
	"distributorId": "WORLD2MEET",
	"supplierId": "IHG",
	"creationDate": {
		$gte: ISODate("2025-04-22T00:00:00Z"),
		$lte: ISODate("2025-04-22T23:59:59Z")
	}
})