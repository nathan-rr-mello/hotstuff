package config

config: {
	replicaHosts: [
        "node1",
        "node2",
        "node3",
        "node4",
        "node5",
        "node6",
        "node7",
        "node8",
	]

	clientHosts: [
		"node9",
	]

    replicas: 8
	clients:  3

    locations: [
        "Dagupan",
        "Sydney",
        "Sydney",
        "Sydney",
        "Sydney",
        "Sydney",
        "Sydney",
        "Sydney",
    ]

    byzantineStrategy: {
		silent: [1, 2, 3]
	}
}
