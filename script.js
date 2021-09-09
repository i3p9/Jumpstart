function totalItv() {
    var input = document.getElementsByName("values");
    let listOfApps = "";
    let finalLink = "curl -fsSL https://raw.githubusercontent.com/i3p9/Jumpstart/main/files/jumpstart.sh | bash -s "
    for (var i=0; i<input.length; i++){
        if (input[i].checked){
            // console.log(input[i].value)
            listOfApps = listOfApps + ' ' +(input[i].value);
        }
    }
    console.log(listOfApps)
    finalLink = finalLink + (listOfApps)
    console.log(finalLink)
    document.getElementsByName("generatedLink")[0].value = finalLink;
}

function clearAll() {
    var input = document.getElementsByName("values");
    for (var i=0; i<input.length; i++){
        if (input[i].checked){
            document.getElementById(input[i].id).checked = false;
        }
    }
}

function toClipboard(){
    var copyText = document.getElementById("generatedLink");
    copyText.select();
    copyText.setSelectionRange(0, 99999); /* For mobile devices */
    navigator.clipboard.writeText(copyText.value);
    console.log("Copied to clipboard");
    document.getElementById("clipboardMessage").style.display = "inline";
    setTimeout(() => {document.getElementById("clipboardMessage").style.display = "none"}, 1000);
}
