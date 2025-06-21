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
  
  // Target flash messages by their specific IDs and common class
  const flashSelectors = [
    '#flash-notice',
    '#flash-alert', 
    '.flash-message'
  ];
  
  let foundFlash = false;
  
  flashSelectors.forEach(selector => {
    const flashMessages = document.querySelectorAll(selector);
    
    flashMessages.forEach((flashDiv) => {
      // Skip if we already processed this element
      if (flashDiv.dataset.flashProcessed) return;
      
      console.log(`✅ FOUND FLASH MESSAGE: ${selector}`);
      console.log(`📝 Text: "${flashDiv.textContent.trim()}"`);
      console.log(`🎨 ID: "${flashDiv.id}", Classes: "${flashDiv.className}"`);
      
      foundFlash = true;
      flashDiv.dataset.flashProcessed = 'true';
      
      // Make sure the container is positioned relatively for absolute positioning
      if (!flashDiv.style.position && !flashDiv.className.includes('fixed')) {
        flashDiv.style.position = 'relative';
      }
      
      // Add close button
      const closeBtn = document.createElement('button');
      closeBtn.innerHTML = '×';
      closeBtn.className = 'flash-close-btn';
      closeBtn.setAttribute('aria-label', 'Close notification');
      closeBtn.style.cssText = `
        position: absolute;
        top: 8px;
        right: 12px;
        background: rgba(0, 0, 0, 0.1);
        border: none;
        border-radius: 50%;
        width: 24px;
        height: 24px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        font-size: 18px;
        line-height: 1;
        color: currentColor;
        transition: background-color 0.2s ease;
        z-index: 10;
      `;
      
      // Hover effect
      closeBtn.addEventListener('mouseenter', function() {
        this.style.backgroundColor = 'rgba(0, 0, 0, 0.2)';
      });
      
      closeBtn.addEventListener('mouseleave', function() {
        this.style.backgroundColor = 'rgba(0, 0, 0, 0.1)';
      });
      
      // Close functionality
      closeBtn.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        console.log('🗑️ Close button clicked!');
        
        // Mark as manually dismissed
        flashDiv.dataset.manuallyDismissed = 'true';
        
        // Fade out animation
        flashDiv.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
        flashDiv.style.opacity = '0';
        flashDiv.style.transform = 'translateY(-10px)';
        
        setTimeout(() => {
          if (flashDiv.parentNode) {
            flashDiv.remove();
          }
        }, 300);
      });
      
      flashDiv.appendChild(closeBtn);
      console.log('➕ Close button added to flash message');
      
      // Auto close after 5 seconds
      setTimeout(() => {
        console.log('⏰ 5 seconds passed - checking if should auto-remove flash message');
        if (flashDiv.parentNode && !flashDiv.dataset.manuallyDismissed) {
          console.log('🚮 Auto-removing flash message');
          // Fade out animation
          flashDiv.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
          flashDiv.style.opacity = '0';
          flashDiv.style.transform = 'translateY(-10px)';
          
          setTimeout(() => {
            if (flashDiv.parentNode) {
              flashDiv.remove();
            }
          }, 500);
        } else if (flashDiv.dataset.manuallyDismissed) {
          console.log('⏸️ Flash message was manually dismissed, skipping auto-remove');
        }
      }, 5000);
    });
  });
  
  if (!foundFlash) {
    console.log('❌ NO FLASH MESSAGES FOUND');
    console.log('📊 Searched using selectors:', flashSelectors);
  }
}

console.log('🏁 APPLICATION.JS FINISHED LOADING');
