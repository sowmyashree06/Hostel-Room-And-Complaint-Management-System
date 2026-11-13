function validateSignup(){
  const p=document.querySelector('[name=password]').value;
  const cp=document.querySelector('[name=confirmPassword]').value;
  const phone=document.querySelector('[name=phone]').value;
  if(p.length<6){alert('Password must contain at least 6 characters');return false;}
  if(p!==cp){alert('Passwords do not match');return false;}
  if(!/^\d{10}$/.test(phone)){alert('Enter a valid 10-digit phone number');return false;}
  return true;
}
