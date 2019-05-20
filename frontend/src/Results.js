import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { BACKEND_URL } from './consts.js';
import { Container, Row, Col, Button, Form, Dropdown, Spinner } from 'react-bootstrap';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSearch } from '@fortawesome/free-solid-svg-icons';
import Search from './Search';
import Card from './Card';
import FilterGroup from './FilterGroup';
import $ from 'jquery';

const Results = ({ points, fromPoint, toPoint, dateFrom, dateTo, isLogged, onRentClick }) => {
	const [state, setState] = useState({
		disabled: false,
		cars: null,
		passengers: "",
		bags: "",
		carType: "",
		doors: "",
		transmission: "",
		ac: "",
		sort: 0,
		fromPoint,
		toPoint,
		dateFrom,
		dateTo,
		sameDropOff: fromPoint === toPoint,
		isLoading: false,
	});
	const handleFilter = (groupId, value) => {
		let newState = { ...state };
		newState[groupId] = value;
		newState.cars = null;
		setState(newState);
	}
	const handleSort = (value) => {
		const t = ["Price (low to high)", "Price (high to low)", "Passengers (more to less)"];
		$("#dropdown-sort").blur().text(t[value]);
		setState({ ...state, sort: value, cars: null });
	}
	const handleClick = () => {
		setState({ ...state, cars: null });
	}
	if (state.cars === null && state.fromPoint && state.fromPoint !== 0 && !state.isLoading) {
		setState({ ...state, isLoading: true });
		let url = BACKEND_URL + `/get_cars.aspx?point_id=${state.fromPoint}& \
			passengers=${state.passengers}&bags=${state.bags}&car_type=${state.carType}& \
			doors=${state.doors}&transmission_type=${state.transmission}&has_ac=${state.ac}& \
			date_from=${state.dateFrom.toISOString().substring(0, 10)}&date_to=${state.dateTo.toISOString().substring(0, 10)}& \
			order_by=${state.sort}`;
		url = url.replace(/\s/ig, "");
		fetch(url)
			.then(response => response.json())
			.then(json => {
				const days = (state.dateFrom ? (state.dateTo.getTime() - state.dateFrom.getTime()) / (60*60*24*1000) : 0) + 1;
				for (let i = 0; json && i < json.length; i++) {
					// Factor 1.5 for different drop-off point used for test purposes
					json[i].price = json[i].pricePerDay * days * (state.sameDropOff ? 1 : 1.5);
					// Old price generator used for test purposes
					if (json[i].carId % 3 === 0)
						json[i].oldPrice = json[i].price * 1.25;
				}
				setState({ ...state, cars: json, isLoading: false });
			})
			.catch(() => {
				setState({ ...state, isLoading: false });
			});
	}

	let cards = !state.isLoading ? [] :
		<div className="h5 text-center mt-4"><Spinner animation="border" role="status" variant="info" /> Loading...</div>;
	for (let i = 0; state.cars && i < state.cars.length; i++) {
		const data = state.cars[i];
		cards.push(
			<Card key={ `car-${data.carId}` }
				data={data}
				button={ isLogged ? "Rent it!" : "" }
				onClick={ (carId, price) => {
					if (onRentClick) {
						const { fromPoint, toPoint, dateFrom, dateTo } = state;
						const data = { carId, price, fromPoint, toPoint,
							dateFrom: dateFrom.toISOString().substring(0, 10),
							dateTo: dateTo.toISOString().substring(0, 10)
							};
						onRentClick(data);
					}
				} }
			/>);
	}
	if (cards.length === 0)
		cards.push(<div key="nothing" className="h5 text-center mt-4">Nothing found. Try to change search parameters.</div>);
	const passState = {
		points,
		dateFrom: state.dateFrom,
		dateTo: state.dateTo,
		sameDropOff: state.sameDropOff, 
		fromPoint: state.fromPoint,
		toPoint: state.toPoint
	};
	return (
		<>
			<Container>
				<Row>
					<Col xs={12} sm={11} md={11} lg={11} xl={11}>
						<Row>
							<Search { ...passState } cols={3} onChange={ (disabled, searchState) => {
								const { dateFrom, dateTo, sameDropOff, fromPoint, toPoint } = searchState;
								setState({ ...state, disabled, dateFrom, dateTo, sameDropOff, fromPoint, toPoint });
								}
							}
							/>
						</Row>
					</Col>
					<Col xs={12} sm={1} md={1} lg={1} xl={1}>
						<br />
						<Button
							variant="info"
							disabled={ state.disabled }
							onClick={ handleClick }
						>
							<FontAwesomeIcon icon={faSearch} size="lg" className="text-white" />
						</Button>
					</Col>
				</Row>
			</Container>
			<Container>
				<Row>
					<Col md="3" className="mt-4">
						<Form className="bg-light p-3 shadow">
							<Form.Group>
								<Form.Label className="font-weight-bold">
									Sorted by
								</Form.Label>
								<Dropdown>
									<Dropdown.Toggle id="dropdown-sort" size="sm" className="mb-3" variant="outline-secondary">
										Price (low to high)
									</Dropdown.Toggle>
									<Dropdown.Menu>
										<Dropdown.Item eventKey={0} onSelect={ handleSort }>Price (low to high)</Dropdown.Item>
										<Dropdown.Item eventKey={1} onSelect={ handleSort }>Price (high to low)</Dropdown.Item>
										<Dropdown.Item eventKey={2} onSelect={ handleSort }>Passengers (more to less)</Dropdown.Item>
									</Dropdown.Menu>
								</Dropdown>
								<Form.Label className="font-weight-bold">
									Capacity
								</Form.Label>
								<FilterGroup 
									caption="Passengers"
									groupId="passengers"
									filters={
										[
											{ label: "1 to 2 passengers", value: "1,2" },
											{ label: "3 to 5 passengers", value: "3,4,5" },
											{ label: "6 or more", value: "6,7,8,9,10" },
										]
									}
									onChange={ handleFilter }
								/>
								<FilterGroup 
									caption="Bags"
									groupId="bags"
									filters={
										[
											{ label: "1 to 2 bags", value: "1,2" },
											{ label: "3 to 4 bags", value: "3,4" },
											{ label: "5 or more", value: "5,6,7,8,9,10" },
										]
									}
									onChange={ handleFilter }
								/>
								<Form.Label className="font-weight-bold">
									Car type
								</Form.Label>
								<FilterGroup 
									groupId="carType"
									filters={
										[
											{ label: "Small", value: "Small" },
											{ label: "Medium", value: "Medium" },
											{ label: "Large", value: "Large" },
											{ label: "SUV", value: "SUV" },
											{ label: "Van", value: "Van" },
											{ label: "Pickup Truck", value: "Pickup Truck" },
											{ label: "Luxury", value: "Luxury" },
											{ label: "Convertible", value: "Convertible" },
										]
									}
									onChange={ handleFilter }
								/>
								<Form.Label className="font-weight-bold">
									Car options
								</Form.Label>
								<FilterGroup 
									caption="Doors"
									groupId="doors"
									filters={
										[
											{ label: "2 doors", value: "2" },
											{ label: "3 doors", value: "3" },
											{ label: "4 doors", value: "4" },
											{ label: "5 doors", value: "5" },
										]
									}
									onChange={ handleFilter }
								/>
								<FilterGroup 
									caption="Transmission"
									groupId="transmission"
									filters={
										[
											{ label: "Automatic", value: "Automatic" },
											{ label: "Manual", value: "Manual" },
										]
									}
									onChange={ handleFilter }
								/>
								<FilterGroup 
									caption="Air-conditioning"
									groupId="ac"
									filters={
										[
											{ label: "Has A/C", value: "1" },
										]
									}
									onChange={ handleFilter }
								/>
							</Form.Group>
						</Form>
					</Col>
					<Col xs="12" md="9">
						{ cards }
					</Col>
				</Row>
			</Container>
			<br /><br />
		</>
	);
}

Results.propTypes = {
	points: PropTypes.array.isRequired,
	dateFrom: PropTypes.objectOf(Date),
	dateTo: PropTypes.objectOf(Date),
	sameDropOff: PropTypes.bool,
	fromPoint: PropTypes.number,
	toPoint: PropTypes.number,
	isLogged: PropTypes.bool.isRequired,
	onRentClick: PropTypes.func
};

export default Results;