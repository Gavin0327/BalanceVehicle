function RTW_rtwnameSIDMap() {
	this.rtwnameHashMap = new Array();
	this.sidHashMap = new Array();
	this.rtwnameHashMap["<Root>"] = {sid: "test"};
	this.sidHashMap["test"] = {rtwname: "<Root>"};
	this.rtwnameHashMap["<S1>"] = {sid: "test:2"};
	this.sidHashMap["test:2"] = {rtwname: "<S1>"};
	this.rtwnameHashMap["<Root>/HAL_GPIO_WritePin"] = {sid: "test:2"};
	this.sidHashMap["test:2"] = {rtwname: "<Root>/HAL_GPIO_WritePin"};
	this.rtwnameHashMap["<S1>:1"] = {sid: "test:2:1"};
	this.sidHashMap["test:2:1"] = {rtwname: "<S1>:1"};
	this.getSID = function(rtwname) { return this.rtwnameHashMap[rtwname];}
	this.getRtwname = function(sid) { return this.sidHashMap[sid];}
}
RTW_rtwnameSIDMap.instance = new RTW_rtwnameSIDMap();
