/* ████████████████████████████████████████████████████████████████████████████████
   LXR Wanted Board - JavaScript
   © 2026 iBoss | wolves.land
   ████████████████████████████████████████████████████████████████████████████████ */

// ════════════════════════════════════════════════════════════════════════════════
// GLOBAL STATE
// ════════════════════════════════════════════════════════════════════════════════

let currentData = null;
let currentWanted = null;
let editMode = false;

// ════════════════════════════════════════════════════════════════════════════════
// MESSAGE LISTENER
// ════════════════════════════════════════════════════════════════════════════════

window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'open':
            openUI(data.data);
            break;
        case 'close':
            closeUI();
            break;
        case 'update':
            updateWantedList(data.data);
            break;
        case 'showPosterOptions':
            showPosterOptions(data.data);
            break;
        case 'showPoster':
            showPoster(data.data);
            break;
    }
});

// ════════════════════════════════════════════════════════════════════════════════
// UI CONTROL FUNCTIONS
// ════════════════════════════════════════════════════════════════════════════════

function openUI(data) {
    currentData = data;
    document.getElementById('app').style.display = 'flex';
    
    // Show action bar if user can create posters
    if (data.permissions && data.permissions.canCreate) {
        document.getElementById('actionBar').style.display = 'flex';
    } else {
        document.getElementById('actionBar').style.display = 'none';
    }
    
    // Display wanted list
    displayWantedList(data.wantedList);
    showWantedList();
}

function closeUI() {
    document.getElementById('app').style.display = 'none';
    currentData = null;
    currentWanted = null;
    editMode = false;
    
    // Send close callback to Lua
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

// ════════════════════════════════════════════════════════════════════════════════
// VIEW MANAGEMENT
// ════════════════════════════════════════════════════════════════════════════════

function showWantedList() {
    document.getElementById('wantedList').style.display = 'grid';
    document.getElementById('wantedDetails').style.display = 'none';
    document.getElementById('wantedForm').style.display = 'none';
}

function showWantedDetails(wanted) {
    currentWanted = wanted;
    
    // Hide list, show details
    document.getElementById('wantedList').style.display = 'none';
    document.getElementById('wantedDetails').style.display = 'block';
    document.getElementById('wantedForm').style.display = 'none';
    
    // Populate details
    document.getElementById('detailsName').textContent = wanted.name;
    document.getElementById('detailsAlias').textContent = wanted.alias || 'Unknown';
    document.getElementById('detailsDescription').textContent = wanted.description || 'No description available';
    document.getElementById('detailsLastSeen').textContent = wanted.last_seen || 'Unknown';
    document.getElementById('detailsReward').textContent = formatCurrency(wanted.reward);
    document.getElementById('detailsIssuedBy').textContent = wanted.issued_by_name || 'Unknown';
    document.getElementById('detailsIssuedDate').textContent = formatDate(wanted.created_at);
    
    // Danger level badge
    const dangerBadge = document.getElementById('detailsDanger');
    dangerBadge.textContent = wanted.danger_level || 'low';
    dangerBadge.className = 'danger-badge danger-' + (wanted.danger_level || 'low');
    
    // Crimes list
    const crimesList = document.getElementById('detailsCrimes');
    crimesList.innerHTML = '';
    if (wanted.crimes) {
        const crimes = wanted.crimes.split(',');
        crimes.forEach(crime => {
            const li = document.createElement('li');
            li.textContent = crime.trim();
            crimesList.appendChild(li);
        });
    }
    
    // Sketch image
    document.getElementById('detailsSketch').src = wanted.sketch_data || 'images/default-sketch.png';
    
    // Show appropriate action buttons
    const permissions = currentData.permissions || {};
    document.getElementById('btnCapture').style.display = currentData.isBountyHunter ? 'block' : 'none';
    document.getElementById('btnEdit').style.display = permissions.canEdit ? 'block' : 'none';
    document.getElementById('btnRemove').style.display = permissions.canRemove ? 'block' : 'none';
}

function showCreateForm() {
    editMode = false;
    currentWanted = null;
    
    // Hide list, show form
    document.getElementById('wantedList').style.display = 'none';
    document.getElementById('wantedDetails').style.display = 'none';
    document.getElementById('wantedForm').style.display = 'block';
    
    // Reset form
    document.getElementById('formTitle').textContent = 'CREATE WANTED POSTER';
    document.getElementById('posterForm').reset();
}

function showEditForm() {
    if (!currentWanted) return;
    
    editMode = true;
    
    // Hide list, show form
    document.getElementById('wantedList').style.display = 'none';
    document.getElementById('wantedDetails').style.display = 'none';
    document.getElementById('wantedForm').style.display = 'block';
    
    // Populate form with current data
    document.getElementById('formTitle').textContent = 'EDIT WANTED POSTER';
    document.getElementById('formCitizenId').value = currentWanted.citizenid;
    document.getElementById('formName').value = currentWanted.name;
    document.getElementById('formAlias').value = currentWanted.alias || '';
    document.getElementById('formCrimes').value = currentWanted.crimes || '';
    document.getElementById('formDescription').value = currentWanted.description || '';
    document.getElementById('formReward').value = currentWanted.reward || 0;
    document.getElementById('formDanger').value = currentWanted.danger_level || 'low';
    document.getElementById('formLastSeen').value = currentWanted.last_seen || '';
    
    // Disable citizen ID field in edit mode
    document.getElementById('formCitizenId').disabled = true;
}

// ════════════════════════════════════════════════════════════════════════════════
// WANTED LIST DISPLAY
// ════════════════════════════════════════════════════════════════════════════════

function displayWantedList(wantedList) {
    const grid = document.getElementById('wantedList');
    grid.innerHTML = '';
    
    if (!wantedList || wantedList.length === 0) {
        grid.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 50px; font-size: 18px; color: #6b5537;">No wanted criminals at this time</div>';
        return;
    }
    
    wantedList.forEach(wanted => {
        const card = createWantedCard(wanted);
        grid.appendChild(card);
    });
}

function createWantedCard(wanted) {
    const card = document.createElement('div');
    card.className = 'wanted-card';
    card.onclick = () => showWantedDetails(wanted);
    
    const dangerClass = 'danger-' + (wanted.danger_level || 'low');
    
    card.innerHTML = `
        <div class="wanted-card-header">
            <h3>WANTED</h3>
        </div>
        <div class="wanted-card-image">
            <img src="${wanted.sketch_data || 'images/default-sketch.png'}" alt="${wanted.name}" onerror="this.src='images/default-sketch.png'">
        </div>
        <div class="wanted-card-name">${wanted.name}</div>
        <div class="wanted-card-info">
            <span>Danger:</span>
            <span class="danger-badge ${dangerClass}">${wanted.danger_level || 'low'}</span>
        </div>
        <div class="wanted-card-reward">
            REWARD: ${formatCurrency(wanted.reward)}
        </div>
    `;
    
    return card;
}

function updateWantedList(wantedList) {
    if (currentData) {
        currentData.wantedList = wantedList;
        displayWantedList(wantedList);
    }
}

// ════════════════════════════════════════════════════════════════════════════════
// ACTION HANDLERS
// ════════════════════════════════════════════════════════════════════════════════

function captureWanted() {
    if (!currentWanted) return;
    
    fetch(`https://${GetParentResourceName()}/captureWanted`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id: currentWanted.id })
    });
    
    closeUI();
}

function editWanted() {
    showEditForm();
}

function removeWanted() {
    if (!currentWanted) return;
    
    if (confirm('Are you sure you want to remove this wanted poster?')) {
        fetch(`https://${GetParentResourceName()}/removeWanted`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: currentWanted.id })
        });
        
        closeUI();
    }
}

// ════════════════════════════════════════════════════════════════════════════════
// FORM SUBMISSION
// ════════════════════════════════════════════════════════════════════════════════

document.getElementById('posterForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = {
        citizenid: document.getElementById('formCitizenId').value,
        name: document.getElementById('formName').value,
        alias: document.getElementById('formAlias').value,
        crimes: document.getElementById('formCrimes').value,
        description: document.getElementById('formDescription').value,
        reward: parseInt(document.getElementById('formReward').value),
        danger_level: document.getElementById('formDanger').value,
        last_seen: document.getElementById('formLastSeen').value
    };
    
    if (editMode && currentWanted) {
        // Update existing poster
        formData.id = currentWanted.id;
        fetch(`https://${GetParentResourceName()}/updateWanted`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(formData)
        });
    } else {
        // Create new poster
        fetch(`https://${GetParentResourceName()}/createWanted`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(formData)
        });
    }
    
    closeUI();
});

// ════════════════════════════════════════════════════════════════════════════════
// UTILITY FUNCTIONS
// ════════════════════════════════════════════════════════════════════════════════

function formatCurrency(amount) {
    return '$' + parseFloat(amount).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
}

function formatDate(dateString) {
    if (!dateString) return 'Unknown';
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });
}

function GetParentResourceName() {
    return window.location.hostname === '' ? 'lxr-wantedboard' : window.location.hostname;
}

// ════════════════════════════════════════════════════════════════════════════════
// KEYBOARD CONTROLS
// ════════════════════════════════════════════════════════════════════════════════

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeUI();
        closePosterView();
    }
});

// ════════════════════════════════════════════════════════════════════════════════
// POSTER ITEM VIEWING (Standalone)
// ════════════════════════════════════════════════════════════════════════════════

let currentPosterData = null;

function showPosterOptions(posterData) {
    currentPosterData = posterData;
    document.getElementById('posterView').style.display = 'flex';
    document.getElementById('posterOptions').style.display = 'block';
    document.getElementById('posterDisplay').style.display = 'none';
}

function viewPosterItem() {
    if (!currentPosterData) return;
    
    document.getElementById('posterOptions').style.display = 'none';
    document.getElementById('posterDisplay').style.display = 'block';
    
    // Populate poster data
    document.getElementById('posterItemName').textContent = currentPosterData.name || 'Unknown';
    document.getElementById('posterItemAlias').textContent = currentPosterData.alias || 'None';
    document.getElementById('posterItemDescription').textContent = currentPosterData.description || 'No description available';
    document.getElementById('posterItemReward').textContent = '$' + (currentPosterData.reward || 0);
    document.getElementById('posterItemLastSeen').textContent = currentPosterData.last_seen || 'Unknown';
    document.getElementById('posterItemIssuer').textContent = currentPosterData.issued_by_name || 'Unknown';
    
    // Set danger level
    const dangerBadge = document.getElementById('posterItemDanger');
    dangerBadge.textContent = (currentPosterData.danger_level || 'low').toUpperCase();
    dangerBadge.className = 'value danger-badge-standalone danger-' + (currentPosterData.danger_level || 'low');
    
    // Set crimes
    const crimesContainer = document.getElementById('posterItemCrimes');
    crimesContainer.innerHTML = '';
    if (currentPosterData.crimes && Array.isArray(currentPosterData.crimes)) {
        currentPosterData.crimes.forEach(crime => {
            const crimeTag = document.createElement('span');
            crimeTag.className = 'crime-tag-standalone';
            crimeTag.textContent = crime;
            crimesContainer.appendChild(crimeTag);
        });
    } else if (currentPosterData.crimes) {
        const crimeTag = document.createElement('span');
        crimeTag.className = 'crime-tag-standalone';
        crimeTag.textContent = currentPosterData.crimes;
        crimesContainer.appendChild(crimeTag);
    }
    
    // Set sketch image
    if (currentPosterData.sketch_data) {
        document.getElementById('posterItemSketch').src = currentPosterData.sketch_data;
    }
}

function placePosterItem() {
    // Notify game to enter placement mode
    fetch('https://lxr-wantedboard/posterOption', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ option: 'place', posterData: currentPosterData })
    });
    
    closePosterView();
}

function showPoster(posterData) {
    currentPosterData = posterData;
    viewPosterItem();
    document.getElementById('posterView').style.display = 'flex';
    document.getElementById('posterOptions').style.display = 'none';
    document.getElementById('posterDisplay').style.display = 'block';
}

function closePosterView() {
    document.getElementById('posterView').style.display = 'none';
    currentPosterData = null;
    
    // Notify game
    fetch('https://lxr-wantedboard/closePoster', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

// ════════════════════════════════════════════════════════════════════════════════
// ════════════════════════════════════════════════════════════════════════════════
