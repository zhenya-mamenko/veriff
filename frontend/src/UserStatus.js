import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { Navbar, Spinner, Modal, Button, Form, Col, Row } from 'react-bootstrap';
import { BACKEND_URL } from './consts.js';
import './UserStatus.css';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSignOutAlt, faUserClock, faUserTimes, faUser } from '@fortawesome/free-solid-svg-icons';
import sha256 from 'sha-256-js';
import $ from 'jquery';

const UserStatus = ({ onChange }) => {
	const loadingStatus = <><Spinner animation="border" role="status" size="sm" /> Loading...</>;
	const [status, setStatus] = useState(loadingStatus);
	const [state, setState] = useState({
		showModal: false,
		isValidated: false,
		isLoading: true
	});
	const logout = <a className="ml-3 align-middle" href="#logout" onClick={ (e) => {
			e.preventDefault();
			e.stopPropagation();
			const url = BACKEND_URL + "/logout.aspx";
			setStatus(loadingStatus);
			fetch(url, { credentials: "include" })
				.then(() => { setState({ ...state, isLoading: true }); })
				.catch(() => { setState({ ...state, isLoading: true }); });
		} }><FontAwesomeIcon icon={faSignOutAlt} size="lg" /></a>
	const defaultStatus = <><a href="#signin" onClick={ (e) => {
			e.preventDefault();
			e.stopPropagation();
			setState({ ...state, showModal: true });
		} }>Sign in</a> or <a href="#signup" onClick={ (e) => {
			e.preventDefault();
			e.stopPropagation();
			if (onChange)
				onChange({ isLogged: false, page: 3 });
		} }>Sign up</a></>;

	const handleProfileClick = (e) => {
		e.preventDefault();
		e.stopPropagation();
		if (onChange)
			onChange({ isLogged: true, page: 2 });
	}

	if (state.isLoading)
	{
		setState({ ...state, isLoading: false });
		fetch(BACKEND_URL + "/get_user_status.aspx", { credentials: "include" })
			.then(response => response.json())
			.then(json => {
				const userName = <span className="text-white">{json.firstName} {json.lastName}</span>;
				switch (json.status) {
					case "approved":
						setStatus(<><a href="#profile" onClick={ handleProfileClick }><FontAwesomeIcon icon={faUser} size="sm" className="mr-1 text-white" /> {userName}</a> {logout}</>);
						break;
					case "resubmission_requested":
					case "declined":
					case "expired":
					case "abandoned":
					case "invalid_document":
						setStatus(<><a href="#profile" onClick={ handleProfileClick }><FontAwesomeIcon icon={faUserTimes} size="sm" className="mr-1 text-danger" /> {userName}</a> {logout}</>);
						break;
					case "submited":
						setStatus(<><a href="#profile" onClick={ handleProfileClick }><FontAwesomeIcon icon={faUserClock} size="sm" className="mr-1 text-warning" /> {userName}</a> {logout}</>);
						break;
					default:
						setStatus(defaultStatus);
				}
				const isLogged = json.status === "approved";
				if (onChange)
					onChange({ isLogged });
			})
		};
	const handleClose = () => {
		$("#errorMessage").addClass("d-none").removeClass("d-block");
		setState({ ...state, showModal: false, isValidated: false });
	}
	const emailPattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
	return (
		<>
			<Navbar.Text>{status}</Navbar.Text>
			<Modal show={ state.showModal } onHide={ handleClose } centered>
				<Modal.Header closeButton>
					<Modal.Title>Sign in</Modal.Title>
				</Modal.Header>
				<Modal.Body>
					<Form
						noValidate
						validated={ state.error }
					>
						<Form.Group controlId="formSigninEmail" as={Row} className="UserStatus-signin mt-3">
							<Form.Label column sm="2">Email</Form.Label>
							<Col sm="10">
								<Form.Control
									type="email"
									placeholder="Enter email"
									required pattern={ emailPattern }
								/>
								<Form.Control.Feedback type="invalid">Enter valid email</Form.Control.Feedback>
							</Col>
						</Form.Group>

						<Form.Group controlId="formSigninPassword" as={Row} className="UserStatus-signin mb-0">
							<Form.Label column sm="2">Password</Form.Label>
							<Col>
								<Form.Control type="password" placeholder="Enter password" required />
								<Form.Control.Feedback type="invalid">Password is required field</Form.Control.Feedback>
							</Col>
						</Form.Group>
					</Form>
					<p id="errorMessage" className="d-none text-danger">Login error. Check email and password and try again.</p>
				</Modal.Body>
				<Modal.Footer>
					<Button variant="secondary" onClick={ handleClose }>
						Close
					</Button>
					<Button variant="info" onClick={ (e) => {
							$("#errorMessage").addClass("d-none").removeClass("d-block");
							const form = e.currentTarget;
							e.preventDefault();
							e.stopPropagation();
							if (form.checkValidity()) {
								const email = $("#formSigninEmail").val();
								const pass = $("#formSigninPassword").val();
								const hash = sha256(pass);
								const url = BACKEND_URL + `/login.aspx?email=${email}&hash=${hash}`;
								fetch(url, { credentials: "include" })
									.then(response => response.json())
									.then(json => {
										if (json && json.status === "logged") {
											$("#formSigninPassword").val("");
											setStatus(loadingStatus);
											setState({ ...state, isValidated: false, showModal: false, isLoading: true });
										}
										else {
											$("#errorMessage").removeClass("d-none").addClass("d-block");
										}
									})
									.catch(() => {
										setState({ ...state, isValidated: false, showModal: false });
										setStatus(defaultStatus);
									});
							}
							else
								setState({ ...state, isValidated: true });
						}
					}>
						Login
					</Button>
				</Modal.Footer>
			</Modal>
		</>
	);
}

UserStatus.propTypes = {
	onChange: PropTypes.func.isRequired,
}

export default UserStatus;