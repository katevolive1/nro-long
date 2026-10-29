(function () {
    'use strict';

    var PETAL_IMAGES = [
        '/images/211.png',
        '/images/212.png',
        '/images/213.png'
    ];
    var PETAL_COUNT = 20;

    function random(min, max) {
        return Math.random() * (max - min) + min;
    }

    function createPetal(index) {
        var petal = document.createElement('img');
        petal.className = 'cherry-petal';
        petal.src = PETAL_IMAGES[index % PETAL_IMAGES.length];
        petal.alt = '';
        petal.setAttribute('aria-hidden', 'true');
        petal.style.left = random(-5, 100) + 'vw';
        petal.style.width = random(14, 28) + 'px';
        petal.style.opacity = random(0.55, 0.95);
        petal.style.animationDuration = random(7, 14) + 's';
        petal.style.animationDelay = random(-14, 0) + 's';
        var drift = random(-140, 140);
        petal.style.setProperty('--drift', drift + 'px');
        petal.style.setProperty('--drift-half', (drift * 0.45) + 'px');
        var spin = random(300, 900);
        petal.style.setProperty('--spin', spin + 'deg');
        petal.style.setProperty('--spin-half', (spin * 0.55) + 'deg');
        return petal;
    }

    function startCherryBlossoms() {
        var container = document.querySelector('.snowEffect');
        if (!container || container.dataset.cherryReady === '1') {
            return;
        }

        container.dataset.cherryReady = '1';
        container.innerHTML = '';

        var fragment = document.createDocumentFragment();
        for (var i = 0; i < PETAL_COUNT; i += 1) {
            fragment.appendChild(createPetal(i));
        }
        container.appendChild(fragment);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', startCherryBlossoms);
    } else {
        startCherryBlossoms();
    }
})();
