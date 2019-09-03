<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="${grailsApplication.config.skin.layout}"/>
    <meta name="breadcrumb" content=""/> <!-- defaults to title below -->
    <title>Places search | ${grailsApplication.config.skin?.orgNameLong}</title>

    <style>
    * {
        box-sizing: border-box;
    }

    body {
        font: 16px Arial;
    }

    /*the container must be positioned relative:*/
    .autocomplete {
        position: relative;
        display: inline-block;
    }

    input {
        border: 1px solid transparent;
        background-color: #f1f1f1;
        padding: 10px;
        font-size: 16px;
    }

    input[type=text] {
        background-color: #f1f1f1;
        width: 100%;
    }

    input[type=submit] {
        background-color: DodgerBlue;
        color: #fff;
        cursor: pointer;
    }

    .autocomplete-items {
        position: absolute;
        border: 1px solid #d4d4d4;
        border-bottom: none;
        border-top: none;
        z-index: 99;
        /*position the autocomplete items to be the same width as the container:*/
        top: 100%;
        left: 0;
        right: 0;
    }

    .autocomplete-items div {
        padding: 10px;
        cursor: pointer;
        background-color: #fff;
        border-bottom: 1px solid #d4d4d4;
    }

    /*when hovering an item:*/
    .autocomplete-items div:hover {
        background-color: #e9e9e9;
    }

    /*when navigating through the items using the arrow keys:*/
    .autocomplete-active {
        background-color: DodgerBlue !important;
        color: #ffffff;
    }
    </style>

</head>


<body class="page-search">

<section class="container">

    <header class="pg-header">
        <h1>Search for places or click the search button to explore all places</h1>
    </header>

    <!--
    <div class="section">
        <div class="row">
            <div class="col-lg-8">
                <form id="search-inpage" action="search" method="get" name="search-form">
                    <div class="input-group">

                        <input id="search" class="form-control ac_input general-search" name="q" type="text" placeholder="Search the Atlas" autocomplete="off">
                        <span class="input-group-btn">
                            <input type="submit" class="form-control btn btn-primary" alt="Search" value="Search">
                        </span>
                    </div>
                </form>
            </div>
        </div>
    </div>
    -->

    <div class="section">
        <div class="row">
            <div class="col-lg-8">
                <form id="search-inpage2" action="search" method="get" name="search-form">
                    <div class="input-group">

                        <input id="myInput" class="form-control ac_input general-search" name="q" type="text" placeholder="Search the Atlas" autocomplete="off">
                        <span class="input-group-btn">
                            <input type="submit" class="form-control btn btn-primary" alt="Search" value="Search">
                        </span>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function autocomplete(inp, arr) {
            /*the autocomplete function takes two arguments,
            the text field element and an array of possible autocompleted values:*/
            var currentFocus;
            /*execute a function when someone writes in the text field:*/
            inp.addEventListener("input", function(e) {
                var a, b, i, val = this.value;
                /*close any already open lists of autocompleted values*/
                closeAllLists();
                if (!val) { return false;}
                currentFocus = -1;
                /*create a DIV element that will contain the items (values):*/
                a = document.createElement("DIV");
                a.setAttribute("id", this.id + "autocomplete-list");
                a.setAttribute("class", "autocomplete-items");
                /*append the DIV element as a child of the autocomplete container:*/
                this.parentNode.appendChild(a);
                /*for each item in the array...*/
                for (i = 0; i < arr.length; i++) {
                    /*check if the item starts with the same letters as the text field value:*/
                    if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
                        /*create a DIV element for each matching element:*/
                        b = document.createElement("DIV");
                        /*make the matching letters bold:*/
                        b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
                        b.innerHTML += arr[i].substr(val.length);
                        /*insert a input field that will hold the current array item's value:*/
                        b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
                        /*execute a function when someone clicks on the item value (DIV element):*/
                        b.addEventListener("click", function(e) {
                            /*insert the value for the autocomplete text field:*/
                            inp.value = this.getElementsByTagName("input")[0].value;
                            /*close the list of autocompleted values,
                            (or any other open lists of autocompleted values:*/
                            closeAllLists();
                        });
                        a.appendChild(b);
                    }
                }
            });
            /*execute a function presses a key on the keyboard:*/
            inp.addEventListener("keydown", function(e) {
                var x = document.getElementById(this.id + "autocomplete-list");
                if (x) x = x.getElementsByTagName("div");
                if (e.keyCode == 40) {
                    /*If the arrow DOWN key is pressed,
                    increase the currentFocus variable:*/
                    currentFocus++;
                    /*and and make the current item more visible:*/
                    addActive(x);
                } else if (e.keyCode == 38) { //up
                    /*If the arrow UP key is pressed,
                    decrease the currentFocus variable:*/
                    currentFocus--;
                    /*and and make the current item more visible:*/
                    addActive(x);
                } else if (e.keyCode == 13) {
                    /*If the ENTER key is pressed, prevent the form from being submitted,*/
                    e.preventDefault();
                    if (currentFocus > -1) {
                        /*and simulate a click on the "active" item:*/
                        if (x) x[currentFocus].click();
                    }
                }
            });
            function addActive(x) {
                /*a function to classify an item as "active":*/
                if (!x) return false;
                /*start by removing the "active" class on all items:*/
                removeActive(x);
                if (currentFocus >= x.length) currentFocus = 0;
                if (currentFocus < 0) currentFocus = (x.length - 1);
                /*add class "autocomplete-active":*/
                x[currentFocus].classList.add("autocomplete-active");
            }
            function removeActive(x) {
                /*a function to remove the "active" class from all autocomplete items:*/
                for (var i = 0; i < x.length; i++) {
                    x[i].classList.remove("autocomplete-active");
                }
            }
            function closeAllLists(elmnt) {
                /*close all autocomplete lists in the document,
                except the one passed as an argument:*/
                var x = document.getElementsByClassName("autocomplete-items");
                for (var i = 0; i < x.length; i++) {
                    if (elmnt != x[i] && elmnt != inp) {
                        x[i].parentNode.removeChild(x[i]);
                    }
                }
            }
            /*execute a function when someone clicks in the document:*/
            document.addEventListener("click", function (e) {
                closeAllLists(e.target);
            });
        }

        /*An array containing all the regions*/

        var regions = [
            "Abney Park Cemetery",
            "Acton Cemetery St Gabriel North Acton",
            "Acton Cemetery St Gabriel North Acton Extension",
            "Adath Yisroel Burial Ground Jesus Church Forty Hill",
            "Alderney Road Cemetery",
            "All Saints All Saints Highgate",
            "All Saints All Saints Margaret Street",
            "All Saints Church All Saints Poplar",
            "All Saints Church All Saints Edmonton",
            "All Saints Church All Saints Fulham",
            "All Saints Church All Saints Harrow Weald",
            "All Saints Church All Saints Laleham",
            "All Souls Church All Souls Langham Place",
            "Alperton Cemetery",
            "Altab Ali Park St Dunstan Stepney",
            "Ashford Burial Ground",
            "Bancroft Road Cemetery",
            "Bedfont Cemetery",
            "Brady Street Cemetery",
            "Brompton Cemetery",
            "Bunhill Fields Cemetery",
            "Cherry Lane Cemetery",
            "Chiswick New Cemetery",
            "Chiswick Old Cemetery",
            "Christ Church Cemetery",
            "Christ Church Christ Church Southgate",
            "Christ Church Cockfosters",
            "Christ Church Spitalfields",
            "Christchurch Gardens St Peter Eaton Square",
            "Christchurch Greyfriars Church",
            "Church Of Holy Cross Greenford",
            "City of Westminister Cemetery",
            "Dovehouse Green St Luke",
            "Drury Lane Gardens St Paul Covent Garden",
            "East Finchley Cemetery",
            "Eastcote Lane Cemetery",
            "Edgwarebury Cemetery",
            "Edmonton Cemetery",
            "Enfield Cemetery",
            "Fairchild Gardens",
            "Federation Cemetery Edmonton",
            "Feltham Cemetery",
            "Fen Court St Olave Hart Street",
            "Fulham Palace Road Cemetery",
            "Globe Road Memorial Gardens",
            "Golders Green parish church",
            "Greenford Park Cemetery Southall",
            "Gunnersbury Cemetery Ealing",
            "Hackney Cemetery",
            "Hammersmith Friends"
        ];

        /*initiate the autocomplete function on the "myInput" element, and pass along the regions array as possible autocomplete values:*/
        autocomplete(document.getElementById("myInput"), regions);
    </script>


</section><!--end .inner-->
</body>
</html>