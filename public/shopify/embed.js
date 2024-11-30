// public/shopify/embed.js
(function() {
  // Get embed token from URL parameter
  const urlParams = new URLSearchParams(document.currentScript.src.split('?')[1]);
  const embedToken = urlParams.get('token');

  function createBuzzwallHQWall() {
    if (!embedToken) return;
    
    const container = document.createElement('div');
    container.id = 'buzzwallhq-container';
    container.style.cssText = 'width: 100%; min-height: 2000px; margin: 20px 0;';

    const iframe = document.createElement('iframe');
    iframe.src = `https://buzzwallhq.com/walls/embed/${embedToken}`;
    iframe.style.cssText = 'width: 100%; min-height: 2018px; border: none;';
    iframe.allowFullscreen = true;

    container.appendChild(iframe);

    // Find a good place to insert on product pages
    const targetElement = 
      document.querySelector('.product-description') ||
      document.querySelector('.product__description') ||
      document.querySelector('[data-section-type="product-template"]');

    if (targetElement) {
      targetElement.after(container);
    }
  }

  // Initialize when page is ready
  if (document.readyState === 'complete') {
    createBuzzwallHQWall();
  } else {
    window.addEventListener('load', createBuzzwallHQWall);
  }
})();