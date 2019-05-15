import React, { useState, useEffect, useRef } from 'react';
import PropTypes from 'prop-types';
import { Form } from 'react-bootstrap';
import './FilterGroup.css';

const FilterGroup = ({ caption, filters, groupId, onChange }) => {
	const [state, setState] = useState({
		value: []
	});
	let latestProps = useRef({ groupId, onChange });
	useEffect(() => {
		latestProps.current = { groupId, onChange };
	});
	useEffect(() => {
		const { groupId, onChange } = latestProps.current;
		if (onChange)
			onChange(groupId, state.value.join(","));
	}, [ state.value ])
	let content = [];
	if (caption)
		content.push(<Form.Label key={ `filtergroup-${groupId}-label` } className="FilterGroup-caption">{caption}</Form.Label>);
	for (let i = 0; i < filters.length; i++) {
		content.push(
			<div key={ `filtergroup-${groupId}-el${i}` }>
				<Form.Check
					custom
					type="checkbox"
					label={ filters[i].label }
					id={ `filtergroup-${groupId}-el${i}` }
					onChange={ () => {
							let idx = state.value.indexOf(filters[i].value);
							let value = [...state.value];
							if (idx === -1)
								value.push(filters[i].value);
							else
								value.splice(idx, 1);
							setState({ ...state, value })
						}
					}
				/>
			</div>
		);
	}
return (
	<div className="mb-2">
		{content}
	</div>
	);
}

FilterGroup.propTypes = {
	caption: PropTypes.string,
	filters: PropTypes.array.isRequired,
	groupId: PropTypes.string.isRequired,
	onChange: PropTypes.func.isRequired
};

export default FilterGroup;