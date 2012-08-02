function crypterPassword(form,cache){
	var pass = form.pass.value;
	var mdp ="";
	mdp = MD5(pass);

	// TODO : SHA-256
	//mdp = hex_sha256(pass);
	mdp = MD5(pass);

	var mot = mdp+cache;
	var cryptogramme = "";

	// TODO : SHA-256
	cryptogramme = MD5(mot);
	//cryptogramme = hex_sha256(mot);

	form.cryptogramme.value = cryptogramme;
	form.pass.value = "";
	return true;
}

function cipherPassword(
		fieldIdPassword,
		fieldIdCryptogram,
		hiddenWord)
{
	var password = $(fieldIdPassword).value;
	var mdp = MD5(password);

	// TODO : SHA-256
	//mdp = hex_sha256(pass);

	var mot = mdp+hiddenWord;
	var cryptogramme ;

	// TODO : SHA-256
	cryptogramme = MD5(mot);
	//cryptogramme = hex_sha256(mot);

	$(fieldIdCryptogram).value = cryptogramme;
	$(fieldIdPassword).value = "";
	return true;
}

//http://zumbrunn.com/mochazone/Spidermonkey+Javascript+1.5+finally+final/
//var digest = makeDigestEncoder2('SHA-512','hello world'); 
//alert(digest);
//var digest = makeDigestEncoder('SHA-512')('hello world'); 
//alert(digest);
/*
makeDigestEncoder  = function(kind) {
    return function(str) {
        if (methodOf(this)) str = this;
        var algorithm = java.security.MessageDigest.getInstance(kind);
        var digest = algorithm.digest(new java.lang.String(str).getBytes());
        var hexdigest = '';
        for (var i = 0; i < digest.length; i++) {
            var b = digest[i] & 0xff;
            if (b < 0x10) hexdigest += "0";
            hexdigest += java.lang.Integer.toHexString(b);
        }
        return hexdigest;
    }
}

makeDigestEncoder2  = function(kind,phrase) {
        var algorithm = java.security.MessageDigest.getInstance(kind);
        var digest = algorithm.digest(new java.lang.String(phrase).getBytes());
        var hexdigest = '';
        for (var i = 0; i < digest.length; i++) {
            var b = digest[i] & 0xff;
            if (b < 0x10) hexdigest += "0";
            hexdigest += java.lang.Integer.toHexString(b);
        }
        return hexdigest;
}
*/