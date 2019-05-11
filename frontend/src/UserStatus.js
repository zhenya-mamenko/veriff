import React, { useState } from 'react';
import { Navbar, Spinner } from 'react-bootstrap';
import { BACKEND_URL } from './consts.js';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSignOutAlt, faUserClock, faUserTimes, faUser } from '@fortawesome/free-solid-svg-icons';

const defaultStatus = <><a href="#login">Sign in</a> or <a href="/signup">Sign up</a></>;
const loadingStatus = <><Spinner animation="border" role="status" size="sm" /> Loading...</>;
const logout = <a className="ml-3 align-middle" href="#logout"><FontAwesomeIcon icon={faSignOutAlt} size="lg" /></a>

const UserStatus = () => {
	const [status, setStatus] = useState(loadingStatus);

	if (status === loadingStatus)
	{
		fetch(BACKEND_URL + "/get_user_status.aspx")
			.then(response => response.json())
			.then(json => {
				const userName = <span className="text-white">{json.firstName} {json.lastName}</span>;
				switch (json.status) {
					case "approved":
						setStatus(<><FontAwesomeIcon icon={faUser} size="sm" className="mr-1 text-white" /> {userName} {logout}</>);
						break;
					case "resubmission_requested":
					case "declined":
					case "expired":
					case "abandoned":
					case "invalid_document":
						setStatus(<><a href="/profile"><FontAwesomeIcon icon={faUserTimes} size="sm" className="mr-1 text-danger" /> {userName}</a> {logout}</>);
						break;
					case "submited":
						setStatus(<><FontAwesomeIcon icon={faUserClock} size="sm" className="mr-1 text-warning" /> {userName} {logout}</>);
						break;
					default:
						setStatus(defaultStatus);
				}
			})
		};
	return <Navbar.Text>{status}</Navbar.Text>;
}

export default UserStatus;