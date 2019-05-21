import React, { useState } from 'react';
import { Container, Spinner, Col, Row } from 'react-bootstrap';
import Card from './Card';
import { BACKEND_URL } from './consts.js';

const Profile = () => {
	const loading = <div className="h5 text-center mt-4"><Spinner animation="border" role="status" variant="info" /> Loading...</div>;
	const [state, setState] = useState({
		data: null,
		cars: null,
		isLoading: false
	});
	const handleReturn = (carId) => {
		const url = BACKEND_URL + `/return.aspx?car_id=${carId}`;
		fetch(url, { credentials: "include" })
			.then(() => { setState({ ...state, cars: null }); })
			.catch(() => { setState({ ...state, cars: null }); });
	}
	const handleResubmit = (e) => {
		e.preventDefault();
		e.stopPropagation();
		// // Add callback to real url (don't work with localhost)
		// let formData = new FormData();
		// formData.append("callback", window.location.href);
		fetch(BACKEND_URL + "/start_session.aspx", {
				credentials: "include",
				method: "POST",
				// body: formData
			})
			.then(response => response.json())
			.then(json => {
				window.location.href = json.url;
			})
			.catch(() => {
				
			})
	}
	if (!state.isLoading && (state.cars === null || state.data === null)) {
		setState({ ...state, isLoading: true });
		let all = [];
		if (state.cars === null) {
			all.push(
				fetch(BACKEND_URL + "/get_rented_cars.aspx", { credentials: "include" })
					.then(response => response.json())
					.then(json => {
						return(json);
					})
					.catch(() => {
						return(null);
					})
			);
		}
		else
			all.push(state.cars);
		if (state.data === null) {
			all.push(
				fetch(BACKEND_URL + "/get_user_status.aspx", { credentials: "include" })
					.then(response => response.json())
					.then(json => {
						const userName = <h3>{json.firstName} {json.lastName}</h3>;
						let data;
						switch (json.status) {
							case "approved":
								data = userName;
								break;
							case "resubmission_requested":
							case "declined":
							case "expired":
							case "abandoned":
							case "invalid_document":
								data = <>{userName}<p>Error in verification ({json.status}). Please, <a href="/#resubmit" onClick={ handleResubmit }>try again</a>.</p></>
								break;
							case "submitted":
								data = <>{userName}<p>Verification status: submitted. Please wait for approving.</p></>
								break;
							default:
								data = null;
						}
						return (data);
					})
					.catch(() => {
						return(null);
					})
			);
		}
		else
			all.push(state.data);
		Promise.all(all).then(values => setState({ ...state, isLoading: false, cars: values[0], data: values[1] }));
	}
	let cards = state.cars !== null ? [] : loading;
	for (let i = 0; state.cars && i < state.cars.length; i++) {
		let data = state.cars[i];
		data.info = <>{ data.doors } doors, { data.transmissionType } transmission{ data.isHasAc ? ", Air-conditioned" : ""}
			<br />Rented: { data.textRentFrom } — { data.textRentUntil }</>;
		cards.push(
			<Card key={ `car-${data.carId}` }
				data={data}
				button={ "Return" }
				onClick={ handleReturn }
			/>);
	}
	if (state.cars !== null && cards.length === 0)
		cards.push(<div key="nothing" className="h5 text-center mt-4">No cars in rent.</div>);

	return (
		<Container>
			<Row>
				<Col>
					{ state.data === null ? loading : state.data }
				</Col>
			</Row>
			<Row>
				<Col>
					{ cards }
				</Col>
			</Row>
		</Container>
	);
}

export default Profile;