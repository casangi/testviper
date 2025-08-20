
window.addEventListener('load', function() {
    // Wait for Allure to load
    setTimeout(function() {
        const headerElement = document.querySelector('.side-nav__brand');
        if (headerElement && !document.querySelector('.back-to-summary')) {
            const backLink = document.createElement('a');
            backLink.href = '../index.html';
            backLink.innerHTML = '← Back to Summary';
            backLink.className = 'back-to-summary';
            backLink.style.cssText = `
                display: block;
                margin-top: 10px;
                padding: 8px 12px;
                background: #007bff;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                font-size: 14px;
                text-align: center;
            `;
            headerElement.appendChild(backLink);
        }
    }, 1000);
});
