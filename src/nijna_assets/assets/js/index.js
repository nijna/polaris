/* specific code to index.html */

function toggleDisplay($element) {
    let classList = $element.classList;
    if (classList.contains('show')) {
        classList.remove('show');
        classList.add('hide');
    } else if (classList.contains('hide')) {
        classList.remove('hide');
        classList.add('show');
    }
}

const $signInButtons = document.querySelectorAll('#signInButton1,#signInButton2');
for (let button=0; button<$signInButtons.length; button++) {
    $signInButtons[button].addEventListener(
        'click',
        async (e) => {
        e.preventDefault();

        const $welcome = document.querySelector('#welcome');
        toggleDisplay($welcome);

        const $login = document.querySelector('#login');
        toggleDisplay($login);
        
        return false;
        }
    );
}

async function loginTrader(e) {
    console.log(e);
    const $loginTrader = document.querySelector('#loginTrader');
    $loginTrader.classList.remove('shadowHover');
    $loginTrader.removeEventListener('click', loginTrader);
    $loginTrader.style["border-radius"] = '0px';
    $loginTrader.style["border-collapse"] = 'collapse';
    $loginTrader.parentElement.style["border-collapse"] = 'collapse';
    $loginTrader.classList.add('rounded-start');
    $loginTrader.classList.remove('m-2');
    $loginTrader.classList.add('ms-2');
    $loginTrader.classList.add('my-2');
    
    const $loginInvestor = document.querySelector('#loginInvestor');
    $loginInvestor.classList.remove('shadowHover');
    toggleDisplay($loginInvestor);

    const $loginTraderDo = document.querySelector('#loginTraderDo');
    toggleDisplay($loginTraderDo);
    $loginTraderDo.style["border-radius"] = '0px';
    $loginTraderDo.classList.add('rounded-end');
    $loginTraderDo.classList.remove('m-2');
    $loginTraderDo.classList.add('me-2');
    $loginTraderDo.classList.add('my-2');

};

const $loginTrader = document.querySelector('#loginTrader');
$loginTrader.addEventListener(
    'click',
    loginTrader
);


/*
// delay until AuthClient is there...
let tryLoading = 3;

checkDependencies = function() {
    if (window.nijna && window.nijna.AuthClient && (typeof window.nijna.AuthClient === 'function')) {
        init();
    } else {
        tryLoading--;
        if (tryLoading) {
            setTimeout(checkDependencies,1000);
        } else {
            console.log('The AuthClient doesn\'t showed up');
            return;
        }
    } 
}

checkDependencies();*/