// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "flowbite"

// Simple console test - no alert popup
console.log('🚀 APPLICATION.JS IS LOADING...');
console.log('🚀 JAVASCRIPT IS WORKING!');

// Auto-dismiss flash messages
document.addEventListener('DOMContentLoaded', function() {
  console.log('🔄 DOMContentLoaded event fired');
  initFlashMessageDismissal();
});

// Also initialize on Turbo visits (for SPA-like navigation)
document.addEventListener('turbo:load', function() {
  console.log('🔄 turbo:load event fired');
  initFlashMessageDismissal();
});

function initFlashMessageDismissal() {
  console.log('🔍 initFlashMessageDismissal function called');
  
  // VERY SIMPLE: Just find ANY div with "successfully" text and green background
  const allDivs = document.querySelectorAll('div');
  console.log(`🔍 Found ${allDivs.length} total div elements on page`);
  
  let foundFlash = false;
  
  allDivs.forEach((div, index) => {
    const text = div.textContent.toLowerCase();
    const classes = div.className;
    
    // Look for any div that contains "successfully" and has green background
    if (text.includes('successfully') && classes.includes('bg-green')) {
      console.log(`✅ FOUND FLASH MESSAGE #${index}!`);
      console.log(`📝 Text: "${text.trim()}"`);
      console.log(`🎨 Classes: "${classes}"`);
      foundFlash = true;
      
      // Add very obvious red border to confirm we found it
      div.style.border = '5px solid red';
      div.style.position = 'relative';
      
      // Add close button
      const closeBtn = document.createElement('div');
      closeBtn.innerHTML = '❌ CLOSE';
      closeBtn.style.position = 'absolute';
      closeBtn.style.top = '10px';
      closeBtn.style.right = '10px';
      closeBtn.style.background = 'red';
      closeBtn.style.color = 'white';
      closeBtn.style.padding = '5px 10px';
      closeBtn.style.cursor = 'pointer';
      closeBtn.style.zIndex = '9999';
      
      closeBtn.onclick = function() {
        console.log('🗑️ Close button clicked!');
        div.remove();
      };
      
      div.appendChild(closeBtn);
      console.log('➕ Close button added to flash message');
      
      // Auto close after 5 seconds
      setTimeout(() => {
        console.log('⏰ 5 seconds passed - auto-removing flash message');
        if (div.parentNode) {
          div.remove();
        }
      }, 5000);
    }
  });
  
  if (!foundFlash) {
    console.log('❌ NO FLASH MESSAGES FOUND');
    console.log('📊 Searched through all divs for text containing "successfully" and classes containing "bg-green"');
  }
}

console.log('🏁 APPLICATION.JS FINISHED LOADING');
